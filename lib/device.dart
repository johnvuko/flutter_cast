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

  Future openUrl(String url) async {
    CastSession session = await CastSessionManager().startSession(this);

    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': 'CC1AD845',
    });

    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': '5C3F0A3C',
    });

    await Future.delayed(const Duration(seconds: 10));

    session.sendMessage(
      CastSession.kNamespaceDashcas,
      {
        'type': 'LOAD',
        'app': 'DashCast',
        'url': url,
        'force': true,
        'reload': 0,
      },
    );
  }

  // TODO: Getting the long token and response2 status is ok, not sure what is the problem,
  // TODO: Reference https://github.com/i8beef/node-red-contrib-castv2/blob/master/lib/YouTubeController.js
  // Future openYouTube(String videoId) async {
  //   try {
  //     // 1. Fetch screen ID
  //     CastSession session = await CastSessionManager().startSession(this);

  //     session.sendMessage(CastSession.kNamespaceReceiver, {
  //       'type': 'LAUNCH',
  //       'appId': '233637DE', // set the appId of your app here
  //     });

  //     session.sendMessage(CastSession.kNamespaceMedia, {
  //       'type': 'LAUNCH',
  //       'appId': 'CC1AD845',
  //     });
  //     await Future.delayed(const Duration(seconds: 10));

  //     // 2. Fetch lounge token

  //     const YOUTUBE_BASE_URL = 'https://www.youtube.com/';
  //     const LOUNGE_TOKEN_URL =
  //         YOUTUBE_BASE_URL + 'api/lounge/pairing/get_lounge_token_batch';
  //     const BIND_URL = YOUTUBE_BASE_URL + 'api/lounge/bc/bind';

  //     http.Response response = await http.post(
  //       Uri.parse(LOUNGE_TOKEN_URL),
  //       headers: <String, String>{
  //         'Origin': YOUTUBE_BASE_URL,
  //       },
  //       body: {'screen_ids': session.sessionId},
  //     );

  //     dynamic responseBody = jsonDecode(response.body);
  //     String loungeToken = (((responseBody as Map)['screens'] as List).first
  //         as Map)['loungeToken'] as String;
  //     print('wow $loungeToken');

  //     // 3. Initialize queue

  //     var url = Uri.parse(BIND_URL); // Replace with your actual BIND_URL
  //     var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  //     var body = {
  //       'count': '0',
  //     };
  //     var queryParams = {
  //       'device': 'REMOTE_CONTROL',
  //       'id': '12345678-9ABC-4DEF-0123-0123456789AB',
  //       'name': 'Desktop&app=youtube-desktop',
  //       'mdx-version': '3',
  //       'loungeIdToken': loungeToken,
  //       'VER': '8',
  //       'v': '2',
  //       't': '1',
  //       'ui': '1',
  //       'RID': '75956',
  //       'CVER': '1',
  //       'method': 'setPlaylist',
  //       'params': Uri.encodeComponent(
  //           '{"videoId":"$videoId","currentTime":5,"currentIndex":0}'),
  //       'TYPE': ''
  //     };
  //     url = url.replace(queryParameters: queryParams);

  //     var response2 = await http.post(url, headers: headers, body: body);
  //     print('response2 is $response2');
  //   } catch (e) {
  //     print('Error casting YouTube');
  //   }
  // }

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

    await session.close();
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
