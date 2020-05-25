class CastDevice {
  /// unique across network
  final String serviceName;

  /// friendly name
  final String name;
  final String host;
  final int port;

  const CastDevice({
    this.serviceName,
    this.name,
    this.host,
    this.port,
  });
}
