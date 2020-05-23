import 'dart:async';

import 'package:mdns_plugin/mdns_plugin.dart';

import 'device.dart';

class CastDiscoveryService {
  static final CastDiscoveryService _instance = CastDiscoveryService._();
  CastDiscoveryService._();

  factory CastDiscoveryService() {
    return _instance;
  }

  List<CastDevice> get devices => _delegate.devices ?? <CastDevice>[];

  Stream<List<CastDevice>> get stream => _controller?.stream;
  StreamController<List<CastDevice>> _controller;

  MDNSPlugin _mdns;
  _Delegate _delegate;

  Future<void> start() async {
    if (_mdns == null) {
      _controller = StreamController<List<CastDevice>>.broadcast();
      _delegate = _Delegate(_controller);
      _mdns = MDNSPlugin(_delegate);
      await _mdns.startDiscovery('_googlecast._tcp', enableUpdating: true);
    }
  }

  Future<void> stop() async {
    await _mdns?.stopDiscovery();
    await _controller?.close();
    _controller = null;
    _delegate = null;
    _mdns = null;
  }
}

class _Delegate implements MDNSPluginDelegate {
  final devices = <CastDevice>[];
  final StreamController<List<CastDevice>> controller;

  _Delegate(this.controller);

  @override
  bool onServiceFound(MDNSService service) {
    return true;
  }

  @override
  void onServiceResolved(MDNSService service) {
    devices.removeWhere((x) => x.serviceName == service.name);

    final device = _transformServiceinDevice(service);
    if (device != null) {
      devices.add(device);
    } else {
      print('[CastDiscoveryService] onServiceResolved unable to read service: $service');
    }

    controller.sink.add(devices);
  }

  @override
  void onServiceUpdated(MDNSService service) {}

  @override
  void onServiceRemoved(MDNSService service) {
    devices.removeWhere((x) => x.serviceName == service.name);
    controller.sink.add(devices);
  }

  @override
  void onDiscoveryStarted() {}

  @override
  void onDiscoveryStopped() {}

  static CastDevice _transformServiceinDevice(MDNSService service) {
    if (service.addresses.isEmpty) {
      return null;
    }

    String name;

    if (service.txt['fn'] != null) {
      name = MDNSService.toUTF8String(service.txt['fn']);
    }
    name ??= service.name;

    return CastDevice(
      serviceName: service.name,
      name: name,
      ip: service.addresses.first,
      port: service.port,
    );
  }
}
