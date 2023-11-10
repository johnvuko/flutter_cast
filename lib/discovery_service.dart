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

  Future<List<CastDevice>> search(
      {Duration timeout = const Duration(seconds: 5)}) async {
    final results = <CastDevice>[];

    final discovery = BonsoirDiscovery(type: _domain);
    await discovery.ready;
    await discovery.start();

    discovery.eventStream!.listen((event) {
      if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
        if (event.service == null || event.service?.attributes == null) {
          return;
        }

        final port = event.service!.port;
        final host = event.service?.toJson()['service.ip'];
        String name = [
          event.service?.attributes?['md'],
          event.service?.attributes?['fn']
        ].whereType<String>().join(' - ');
        if (name.isEmpty) {
          name = event.service!.name;
        }

        if (host == null) {
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

    await Future.delayed(timeout);
    await discovery.stop();

    return results.toSet().toList();
  }
}
