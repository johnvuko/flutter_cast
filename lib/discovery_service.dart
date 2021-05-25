import 'dart:async';

import 'package:multicast_dns/multicast_dns.dart';

import 'device.dart';

const _domain = '_googlecast._tcp.local';

class CastDiscoveryService {
  static final CastDiscoveryService _instance = CastDiscoveryService._();
  CastDiscoveryService._();

  factory CastDiscoveryService() {
    return _instance;
  }

  Future<List<CastDevice>> search({Duration timeout = const Duration(seconds: 5)}) async {
    final results = <CastDevice>[];
    final client = MDnsClient();

    await client.start();

    await for (PtrResourceRecord ptr in client.lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer(_domain), timeout: timeout)) {
      if (results.any((x) => x.serviceName == ptr.domainName)) {
        continue;
      }

      await for (final srv in client.lookup<SrvResourceRecord>(ResourceRecordQuery.service(ptr.domainName))) {
        final serviceName = ptr.domainName;
        final port = srv.port;
        String host = srv.target; // doesn't seem to work, => resolve IPv4
        Map<String, String>? extras;

        String? nameFromExtras;
        final nameFromDomain = ptr.domainName.replaceAll('.$_domain', '').replaceAll(srv.target.replaceAll('.local', '').replaceAll('-', ''), '').replaceAll('-', ' ').trim();

        await for (final ipAddress in client.lookup<IPAddressResourceRecord>(ResourceRecordQuery.addressIPv4(srv.target))) {
          host = ipAddress.address.address;
        }

        if (host == srv.target) {
          await for (final ipAddress in client.lookup<IPAddressResourceRecord>(ResourceRecordQuery.addressIPv6(srv.target))) {
            host = ipAddress.address.address;
          }
        }

        await for (final text in client.lookup<TxtResourceRecord>(ResourceRecordQuery.text(ptr.domainName))) {
          extras = text.text.split('\n').fold<Map<String, String>>(<String, String>{}, (Map<String, String> acc, line) {
            final values = line.split('=');

            if (values.length < 2) {
              return acc;
            }

            final key = values.first;
            final value = values.skip(1).join('');

            acc[key] = value;
            return acc;
          });

          if (extras['fn']?.isNotEmpty ?? false) {
            nameFromExtras = extras['fn']; // Chromecast function (Office, Living room...)
          } else if (extras['md']?.isNotEmpty ?? false) {
            nameFromExtras = extras['md']; // Chromecast model (Chromecast Ultra...)
          }
        }

        final device = CastDevice(
          serviceName: serviceName,
          name: nameFromExtras ?? nameFromDomain,
          host: host,
          port: port,
          extras: extras ?? {},
        );

        results.add(device);
      }
    }

    client.stop();

    return results.toSet().toList();
  }
}
