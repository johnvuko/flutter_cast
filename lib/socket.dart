import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'cast_channel/cast_channel.pb.dart';

class CastSocketMessage {
  final String namespace;
  final Map<String, dynamic> payload;

  const CastSocketMessage(this.namespace, this.payload);
}

class CastSocket {
  Stream<CastSocketMessage> get stream => _controller.stream;

  final SecureSocket _socket;
  int _requestId = 0;
  final _controller = StreamController<CastSocketMessage>.broadcast();

  CastSocket._(this._socket);

  static Future<CastSocket> connect(String host, int port, [Duration? timeout]) async {
    timeout ??= Duration(seconds: 10);

    final _socket = await SecureSocket.connect(
      host,
      port,
      onBadCertificate: (X509Certificate certificate) => true, // chromecast use self-signed certificate
      timeout: timeout,
    );

    final socket = CastSocket._(_socket);
    socket._startListening();

    return socket;
  }

  void _startListening() {
    _socket.listen((event) {
      // happen
      if (_controller.isClosed) {
        return;
      }

      List<int> slice = event.getRange(4, event.length).toList();
      CastMessage message = CastMessage.fromBuffer(slice);

      Map<String, dynamic> payload = jsonDecode(message.payloadUtf8);
      _controller.add(CastSocketMessage(message.namespace, payload));
    }, onError: (error) {
      _controller.addError(error);
    }, onDone: () {
      _controller.close();
    }, cancelOnError: false);
  }

  Future<dynamic> close() {
    return _socket.close();
  }

  void sendMessage(String namespace, String sourceId, String destinationId, Map<String, dynamic> payload) {
    if (payload['requestId'] == null) {
      payload['requestId'] = _requestId;
      _requestId += 1;
    }

    CastMessage castMessage = CastMessage();
    castMessage.protocolVersion = CastMessage_ProtocolVersion.CASTV2_1_0;
    castMessage.sourceId = sourceId;
    castMessage.destinationId = destinationId;
    castMessage.namespace = namespace;
    castMessage.payloadType = CastMessage_PayloadType.STRING;
    castMessage.payloadUtf8 = jsonEncode(payload);

    Uint8List bytes = castMessage.writeToBuffer();
    Uint32List headers = Uint32List.fromList(_writeUInt32BE(List<int>.filled(4, 0), bytes.lengthInBytes));
    Uint32List data = Uint32List.fromList(headers.toList()..addAll(bytes.toList()));

    _socket.add(data);
  }

  Future<dynamic> flush() {
    return _socket.flush();
  }

  static final Function _writeUInt32BE = (target, value) {
    target[0] = ((value & 0xffffffff) >> 24);
    target[1] = ((value & 0xffffffff) >> 16);
    target[2] = ((value & 0xffffffff) >> 8);
    target[3] = ((value & 0xffffffff) & 0xff);
    return target;
  };
}
