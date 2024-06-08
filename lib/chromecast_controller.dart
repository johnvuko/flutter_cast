import 'package:cast/cast.dart';
import 'package:cast/model/receiver_status.dart';
import 'package:cast/model/stream_type.dart';
import 'package:flutter/material.dart';

class ChromecastController {
  static final ChromecastController _instance =
      ChromecastController._internal();

  factory ChromecastController() {
    return _instance;
  }

  ChromecastController._internal();

  final ValueNotifier<int> currentTimeNotifier = ValueNotifier<int>(0);
  final ValueNotifier<String> playerStateNotifier =
      ValueNotifier<String>("IDLE");
  final ValueNotifier<bool> standByNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<List<CastDevice>> devicesNotifier =
      ValueNotifier<List<CastDevice>>([]);
  final ValueNotifier<CastSessionState> sessionState = ValueNotifier<CastSessionState>(CastSessionState.connecting);

  bool hasError = false;
  String? error;

  CastSession? session;

  Future<void> startSearch() async {
    try {
      devicesNotifier.value = await CastDiscoveryService().search();
      hasError = false;
    } catch (e) {
      hasError = true;
      error = e.toString();
    }
  }

  Future<void> connectAndPlayMedia(
    BuildContext context,
    CastDevice device, {
    required String appId,
    required String url,
    required String title,
    StreamType streamType = StreamType.BUFFERED,
    double startTime = 0,
  }) async {
    if (session != null) {
      closeSession();
    }
    session = await CastSessionManager().startSession(device);

    session!.stateStream.listen((state) {
      sessionState.value = state;
      if (state == CastSessionState.connected) {
        Future.delayed(Duration(seconds: 5)).then((x) {
          _sendMessagePlayVideo(session!, url, title, startTime,
              streamType: streamType);
        });
      }
    });

    session!.messageStream.listen((message) {
      ReceiverStatus receiverStatus = ReceiverStatus.fromJson(message);
      if (receiverStatus.type == 'RECEIVER_STATUS') {
        standByNotifier.value = receiverStatus.status?.isStandBy ?? false;
      } else if (receiverStatus.type == 'MEDIA_STATUS') {
        if (receiverStatus.mediaStatus?.isNotEmpty ?? false) {
          var media = receiverStatus.mediaStatus?.first;
          currentTimeNotifier.value = media?.currentTime?.toInt() ?? 0;
          playerStateNotifier.value = media?.playerState ?? 'IDLE';
        }
      }
    });

    session!.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': appId,
    });
  }

  void _sendMessagePlayVideo(
      CastSession session, String url, String title, double startTime,
      {StreamType streamType = StreamType.BUFFERED}) {
    var message = {
      'contentId': url,
      'contentType': 'application/x-mpegURL',
      'streamType': streamType.name, // BUFFERED or LIVE
      'metadata': {'type': 0, 'metadataType': 0, 'title': title, 'images': []}
    };

    session.sendMessage(CastSession.kNamespaceMedia, {
      'type': 'LOAD',
      'autoPlay': true,
      'currentTime': startTime,
      'media': message,
    });
  }

  void closeSession() {
    session?.close();
    session = null;
  }
}
