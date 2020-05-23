class CastDevice {
  /// unique across network
  final String serviceName;

  /// friendly name
  final String name;
  final String ip;
  final int port;

  const CastDevice({
    this.serviceName,
    this.name,
    this.ip,
    this.port,
  });
}
