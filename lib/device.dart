import 'package:bonsoir/bonsoir.dart';

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
}

class CastDeviceWAvailabilty extends CastDevice {
  // Specifies if device was found or has been lost
  final bool isAvailable;

  CastDeviceWAvailabilty({
    required this.isAvailable,
    required super.serviceName,
    required super.name,
    required super.host,
    required super.port,
    required super.extras,
  });

  factory CastDeviceWAvailabilty.fromBonsoirServiceEvent(
    BonsoirService service,
    bool isAvailable,
  ) {
    final port = service.port;
    final host =
        service.toJson()['service.ip'] ?? service.toJson()['service.host'];
    if (host == null) {
      throw 'Could not resolve service';
    }

    String name = [
      service.attributes?['md'],
      service.attributes?['fn'],
    ].whereType<String>().join(' - ');
    if (name.isEmpty) {
      name = service.name;
    }
    return CastDeviceWAvailabilty(
      serviceName: service.name,
      name: name,
      host: host,
      port: port,
      extras: service.attributes ?? {},
      isAvailable: isAvailable,
    );
  }
}
