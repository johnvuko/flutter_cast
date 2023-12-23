import 'dart:async';

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

  // Working only on YouTube
  Future playButton() => sendSingleRequest(CastSession.kNamespaceMedia, 'PLAY');
  // Working only on YouTube
  Future pauseButton() =>
      sendSingleRequest(CastSession.kNamespaceMedia, 'PAUSE');

  Future setVolume(double level) => sendSingleRequestBefore(
        CastSession.kNamespaceReceiver,
        'SET_VOLUME',
        payload: {
          'volume': {
            'level': level,
            'muted': false,
          },
        },
      );

  Future launchAppId(String appId) async {
    CastSession session = await CastSessionManager().startSession(this);

    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': appId,
    });
  }

  Future openMedia({
    required String url,
    required String? title,
    required String coverImage,
  }) async {
    CastSession session = await CastSessionManager().startSession(this);

    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': 'CC1AD845', // set the appId of your app here
    });

    await Future.delayed(const Duration(seconds: 10));

    var message = {
      // Here you can plug an URL to any mp4, webm, mp3 or jpg file with the proper contentType.
      'contentId': url,
      'contentType': 'video/mp4',
      'streamType': 'BUFFERED', // or LIVE

      // Title and cover displayed while buffering
      'metadata': {
        'type': 0,
        'metadataType': 0,
        'title': title,
        'images': [
          {
            'url': coverImage,
          }
        ]
      }
    };
    session.sendMessage(CastSession.kNamespaceMedia, {
      'type': 'LOAD',
      'autoPlay': true,
      'currentTime': 0,
      'media': message,
    });
  }

  Future volumeUp(double level) async {
    double? volume = await getVolume();
    if (volume == null) {
      print('Error setting new volume');
      return;
    }
    await setVolume(volume + level);
  }

  Future volumeDown(double level) async {
    double? volume = await getVolume();
    if (volume == null) {
      print('Error setting new volume');
      return;
    }
    await setVolume(volume - level);
  }

  Future<Map<String, dynamic>?> getStatus() async {
    CastSession session = await CastSessionManager().startSession(this);
    Map<String, dynamic>? messageTemp;

    session.getStatus();

    await for (Map<String, dynamic> message in session.messageStream) {
      if (message['type'] == 'RECEIVER_STATUS') {
        messageTemp = message;
        break;
      }
    }

    session.close();
    return messageTemp;
  }

  Future<double?> getVolume() async {
    Map<String, dynamic>? status = await getStatus();
    if (status == null) {
      return null;
    }
    return status['status']?['volume']?['level'];
  }

  Future sendSingleRequest(
    String kNameSpace,
    String type, {
    Map<String, dynamic>? payload,
  }) async {
    CastSession session =
        await CastSessionManager().startSessionUntillConnected(this);

    if (session.state == CastSessionState.connected) {
      Map<String, dynamic> requestBody = {'type': type};
      requestBody.addAll(payload ?? <String, dynamic>{});

      session.sendMessage(kNameSpace, requestBody);

      await Future.delayed(Duration(microseconds: 100));

      await session.close();
    } else {
      print('Cant change state ${session.state}');
    }
  }

  Future sendSingleRequestBefore(
    String kNameSpace,
    String type, {
    Map<String, dynamic>? payload,
    bool close = true,
  }) async {
    CastSession session = await CastSessionManager().startSession(this);

    Map<String, dynamic> requestBody = {'type': type};
    requestBody.addAll(payload ?? <String, dynamic>{});

    session.sendMessage(kNameSpace, requestBody);

    if (!close) {
      return;
    }

    session.stateStream.listen((state) {
      if (state == CastSessionState.connected) {
        session.close();
      }
    });
  }
}
