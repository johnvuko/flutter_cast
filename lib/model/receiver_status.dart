class ReceiverStatus {
  final int? requestId;
  final Status? status;
  final String? type;
  final List<MediaStatus>? mediaStatus;

  ReceiverStatus({this.requestId, this.status, this.type, this.mediaStatus});

  factory ReceiverStatus.fromJson(Map<String, dynamic> json) {
    var statusData = json['status'];

    Status? status;
    List<MediaStatus>? mediaStatus;

    if (statusData is Map<String, dynamic>) {
      status = Status.fromJson(statusData);
    } else if (statusData is List) {
      mediaStatus = statusData.map((e) => MediaStatus.fromJson(e)).toList();
    }

    return ReceiverStatus(
      requestId: json['requestId'] as int?,
      status: status,
      type: json['type'] as String?,
      mediaStatus: mediaStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'status': status?.toJson(),
      'type': type,
      'mediaStatus': mediaStatus?.map((e) => e.toJson()).toList(),
    };
  }
}

class Status {
  final List<Application>? applications;
  final bool? isActiveInput;
  final bool? isStandBy;
  final Map<String, dynamic>? userEq;
  final Volume? volume;

  Status({this.applications, this.isActiveInput, this.isStandBy, this.userEq, this.volume});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      applications: (json['applications'] as List<dynamic>?)
          ?.map((e) => Application.fromJson(e))
          .toList(),
      isActiveInput: json['isActiveInput'] as bool?,
      isStandBy: json['isStandBy'] as bool?,
      userEq: json['userEq'] as Map<String, dynamic>?,
      volume: json['volume'] != null ? Volume.fromJson(json['volume']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'applications': applications?.map((e) => e.toJson()).toList(),
      'isActiveInput': isActiveInput,
      'isStandBy': isStandBy,
      'userEq': userEq,
      'volume': volume?.toJson(),
    };
  }
}

class Application {
  final String? appId;
  final String? appType;
  final String? displayName;
  final String? iconUrl;
  final bool? isIdleScreen;
  final bool? launchedFromCloud;
  final List<Namespace>? namespaces;
  final bool? senderConnected;
  final String? sessionId;
  final String? statusText;
  final String? transportId;
  final String? universalAppId;

  Application({
    this.appId,
    this.appType,
    this.displayName,
    this.iconUrl,
    this.isIdleScreen,
    this.launchedFromCloud,
    this.namespaces,
    this.senderConnected,
    this.sessionId,
    this.statusText,
    this.transportId,
    this.universalAppId,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      appId: json['appId'] as String?,
      appType: json['appType'] as String?,
      displayName: json['displayName'] as String?,
      iconUrl: json['iconUrl'] as String?,
      isIdleScreen: json['isIdleScreen'] as bool?,
      launchedFromCloud: json['launchedFromCloud'] as bool?,
      namespaces: (json['namespaces'] as List<dynamic>?)
          ?.map((e) => Namespace.fromJson(e))
          .toList(),
      senderConnected: json['senderConnected'] as bool?,
      sessionId: json['sessionId'] as String?,
      statusText: json['statusText'] as String?,
      transportId: json['transportId'] as String?,
      universalAppId: json['universalAppId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appId': appId,
      'appType': appType,
      'displayName': displayName,
      'iconUrl': iconUrl,
      'isIdleScreen': isIdleScreen,
      'launchedFromCloud': launchedFromCloud,
      'namespaces': namespaces?.map((e) => e.toJson()).toList(),
      'senderConnected': senderConnected,
      'sessionId': sessionId,
      'statusText': statusText,
      'transportId': transportId,
      'universalAppId': universalAppId,
    };
  }
}

class Namespace {
  final String? name;

  Namespace({this.name});

  factory Namespace.fromJson(Map<String, dynamic> json) {
    return Namespace(
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class Volume {
  final String? controlType;
  final double? level;
  final bool? muted;
  final double? stepInterval;

  Volume({this.controlType, this.level, this.muted, this.stepInterval});

  factory Volume.fromJson(Map<String, dynamic> json) {
    return Volume(
      controlType: json['controlType'] as String?,
      level: (json['level'] as num?)?.toDouble(),
      muted: json['muted'] as bool?,
      stepInterval: (json['stepInterval'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'controlType': controlType,
      'level': level,
      'muted': muted,
      'stepInterval': stepInterval,
    };
  }
}

class MediaStatus {
  final int? mediaSessionId;
  final int? playbackRate;
  final String? playerState;
  final double? currentTime;
  final int? supportedMediaCommands;
  final Volume? volume;
  final List<int>? activeTrackIds;
  final int? currentItemId;
  final String? repeatMode;

  MediaStatus({
    this.mediaSessionId,
    this.playbackRate,
    this.playerState,
    this.currentTime,
    this.supportedMediaCommands,
    this.volume,
    this.activeTrackIds,
    this.currentItemId,
    this.repeatMode,
  });

  factory MediaStatus.fromJson(Map<String, dynamic> json) {
    return MediaStatus(
      mediaSessionId: json['mediaSessionId'] as int?,
      playbackRate: json['playbackRate'] as int?,
      playerState: json['playerState'] as String?,
      currentTime: (json['currentTime'] as num?)?.toDouble(),
      supportedMediaCommands: json['supportedMediaCommands'] as int?,
      volume: json['volume'] != null ? Volume.fromJson(json['volume']) : null,
      activeTrackIds: (json['activeTrackIds'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      currentItemId: json['currentItemId'] as int?,
      repeatMode: json['repeatMode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mediaSessionId': mediaSessionId,
      'playbackRate': playbackRate,
      'playerState': playerState,
      'currentTime': currentTime,
      'supportedMediaCommands': supportedMediaCommands,
      'volume': volume?.toJson(),
      'activeTrackIds': activeTrackIds,
      'currentItemId': currentItemId,
      'repeatMode': repeatMode,
    };
  }
}
