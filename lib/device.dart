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
  bool operator ==(Object other) => identical(this, other) || (other is CastDevice && runtimeType == other.runtimeType && other.serviceName == serviceName);

  @override
  int get hashCode => serviceName.hashCode;
}
