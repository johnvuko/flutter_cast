import 'dart:async';

import 'package:bonsoir/bonsoir.dart';

import 'device.dart';

const _domain = '_googlecast._tcp';

class CastDiscoveryService {
  static final CastDiscoveryService _instance = CastDiscoveryService._();
  CastDiscoveryService._();

  factory CastDiscoveryService() {
    return _instance;
  }

  Future<List<CastDevice>> search({Duration timeout = const Duration(seconds: 5)}) async {
    final results = <CastDevice>[];

    final discovery = BonsoirDiscovery(type: _domain);
    await discovery.ready;

    discovery.eventStream!.listen((event) {
      if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
        event.service?.resolve(discovery.serviceResolver);
      } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
        if (event.service == null || event.service?.attributes == null) {
          return;
        }

        final port = event.service?.port;
        final host = event.service?.toJson()['service.ip'] ?? event.service?.toJson()['service.host'];

        String name = [
          event.service?.attributes?['md'],
          event.service?.attributes?['fn'],
        ].whereType<String>().join(' - ');
        if (name.isEmpty) {
          name = event.service!.name;
        }

        if (port == null || host == null) {
          return;
        }

        results.add(
          CastDevice(
            serviceName: event.service!.name,
            name: name,
            port: port,
            host: host,
            extras: event.service!.attributes ?? {},
          ),
        );
      }
    }, onError: (error) {
      print('[CastDiscoveryService] error ${error.runtimeType} - $error');
    });

    await discovery.start();
    await Future.delayed(timeout);
    await discovery.stop();

    return results.toSet().toList();
  }
}
