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

  /// Searches for Cast devices and returns a List of discovered devices.
  /// This method is synchronous, meaning it will wait for [timeout] duration.
  /// Use [searchStream] for asynchronous (stream) reponse.
  ///
  /// The returned list containes resolved Devices (host and port is already resolved).
  /// The discovery process runs for [timeout] and then stops.
  Future<List<CastDevice>> search(
      {Duration timeout = const Duration(seconds: 5)}) async {
    final results = <CastDevice>{};

    final discovery = BonsoirDiscovery(type: _domain);
    await discovery.ready;
    late StreamSubscription<BonsoirDiscoveryEvent> subscription;
    try {
      subscription = discovery.eventStream!.listen((event) {
        final availEvent =
            _serviceEventHandler(event, discovery.serviceResolver);
        if (availEvent != null) {
          if (availEvent.isAvailable) {
            results.add(availEvent);
          } else {
            results.remove(availEvent);
          }
        }
      }, onError: (error) {
        print('[CastDiscoveryService] error ${error.runtimeType} - $error');
      });

      await discovery.start();
      await Future.delayed(timeout);
      await discovery.stop();
    } finally {
      await subscription.cancel();
    }

    return results.toList();
  }

  /// Searches for Cast devices and returns a stream of discovered devices.
  /// Always check for [isAvailable] attribute to check if device is no longer active.
  ///
  /// The returned stream emits a `CastDevice` each time a device is Resolved.
  ///
  /// The discovery process runs for [timeout] and then stops and the stream
  /// is closed.
  Stream<CastDeviceWAvailabilty> searchStream({
    Duration timeout = const Duration(seconds: 5),
  }) async* {
    final discovery = BonsoirDiscovery(type: _domain);
    late Stream<CastDeviceWAvailabilty> stream;

    try {
      await discovery.ready;
      stream = discovery.eventStream!
          .map(
              (event) => _serviceEventHandler(event, discovery.serviceResolver))
          .where((d) => d != null)
          .cast<CastDeviceWAvailabilty>()
          .timeout(
        timeout,
        onTimeout: (sink) {
          sink.close();
        },
      );
      await discovery.start();
      yield* stream;
    } finally {
      await discovery.stop();
    }
  }

  // Event handler for bonsoir discovery event stream.
  // Resolves the service if not yet done, and returns CastDeviceAvailabilityEvent for
  // resolved service events (found and lost). Other events are dismissed.
  CastDeviceWAvailabilty? _serviceEventHandler(
    BonsoirDiscoveryEvent event,
    ServiceResolver serviceResolver,
  ) {
    switch (event.type) {
      case BonsoirDiscoveryEventType.discoveryServiceFound:
        event.service?.resolve(serviceResolver);
        break;
      case BonsoirDiscoveryEventType.discoveryServiceResolved:
      case BonsoirDiscoveryEventType.discoveryServiceLost:
        if (event.service == null || event.service!.attributes == null) {
          return null;
        } else {
          final resolved =
              event.type == BonsoirDiscoveryEventType.discoveryServiceResolved;
          return CastDeviceWAvailabilty.fromBonsoirServiceEvent(
            event.service!,
            resolved,
          );
        }
      default:
        return null;
    }
  }
}
