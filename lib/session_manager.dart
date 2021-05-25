import 'dart:math';

import 'package:cast/device.dart';
import 'package:cast/session.dart';

class CastSessionManager {
  static final CastSessionManager _instance = CastSessionManager._();
  CastSessionManager._();

  factory CastSessionManager() {
    return _instance;
  }

  final sessions = <CastSession>[];

  Future<CastSession> startSession(CastDevice device, [Duration? timeout]) async {
    String sessionId = 'client-${Random().nextInt(99999)}';

    while (sessions.contains((x) => x.sessionId == sessionId)) {
      sessionId = 'client-${Random().nextInt(99999)}';
    }

    final session = await CastSession.connect(sessionId, device, timeout);

    sessions.add(session);

    return session;
  }

  Future<dynamic> endSession(String sessionId) async {
    // cast required to avoid adding `collection` dependency
    // https://github.com/dart-lang/sdk/issues/42947
    final session = sessions.cast<CastSession?>().firstWhere((x) => x?.sessionId == sessionId, orElse: () => null);
    if (session == null) {
      return;
    }

    sessions.removeWhere((x) => x.sessionId == sessionId);
    return session.close();
  }
}
