import 'package:cast/cast.dart';

class CastDevice {
  /// unique across network
  final String serviceName;

  /// friendly name
  final String name;
  final String host;
  final int port;

  final Map<String, String> extras;

  const CastDevice({
    required this.serviceName,
    required this.name,
    required this.host,
    required this.port,
    this.extras = const <String, String>{},
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CastDevice &&
          runtimeType == other.runtimeType &&
          other.serviceName == serviceName);

  @override
  int get hashCode => serviceName.hashCode;

  /// Input should be between 0 and 1.
  Future setVolume(double level) => _sendSingleRequest(
        CastSession.kNamespaceReceiver,
        'SET_VOLUME',
        payload: {
          'volume': {
            'level': level,
            'muted': false,
          },
        },
      );

  Future playButton() =>
      _sendSingleRequest(CastSession.kNamespaceMedia, 'PLAY');
  Future pauseButton() =>
      _sendSingleRequest(CastSession.kNamespaceMedia, 'PAUSE');

  Future _sendSingleRequest(
    String receiver,
    String type, {
    Map<String, dynamic>? payload,
  }) async {
    CastSession session =
        await CastSessionManager().startSessionUntillConnected(this);

    if (session.state == CastSessionState.connected) {
      Map<String, dynamic> requestBody = {};
      requestBody.addEntries([MapEntry('type', type)]);
      requestBody.addAll(payload ?? <String, dynamic>{});

      session.sendMessage(receiver, requestBody);

      await Future.delayed(Duration(microseconds: 200));

      await session.close();
    } else {
      print('Cant change state ${session.state}');
    }
  }
}
