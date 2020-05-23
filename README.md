# cast

Dart package to discover and connect with Chromecast devices

## Usage

```
CastDiscoveryService().start();

Widget build(BuildContext context) {
  StreamBuilder<List<CastDevice>>(
    stream: CastDiscoveryService().stream,
    initialData: CastDiscoveryService().devices,
    builder: (context, snapshot) {
      return Column(
        children: snapshot.data.map((device) {
          return ListTile(
            title: Text(device.name),
            onTap: () {
              _connect(context, device);
            },
          );
        }).toList(),
      );
    },
  );
}

Future<void> _connect(BuildContext context, CastDevice object) async {
  final session = await CastSessionManager().startSession(object);

  session.stateStream.listen((state) {
    if (state == CastSessionState.connected) {
      session.sendMessage('urn:x-cast:namespace-of-the-app', {
        'type': 'sample',
      });
    }
  });

  session.sendMessage(CastSession.kNamespaceReceiver, {
    'type': 'LAUNCH',
    'appId': 'YouTube',
  });
}

```

## Build

// https://docs.rs/crate/gcast/0.1.5/source/PROTOCOL.md

    $ pub global activate protoc_plugin
    $ export PATH="$PATH":"$HOME/.pub-cache/bin"
    $ protoc -I=./lib/cast_channel --dart_out=./lib/cast_channel ./lib/cast_channel/cast_channel.proto --plugin "pub run protoc_plugin"
