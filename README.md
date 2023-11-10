# cast

Dart package to discover and connect with Chromecast devices

## Installation

Add this to your package's pubspec.yaml file:

```
dependencies:
  cast: ^1.1.0
```

### iOS

Required iOS 13 minimum.
Since iOS 14 a few more steps are required https://developers.google.com/cast/docs/ios_sender/ios_permissions_changes

In `ios/Runner/Info.plist` add:

```xml
<key>NSBonjourServices</key>
<array>
  <string>_googlecast._tcp</string>
  <string>_YOUR_APP_ID._googlecast._tcp</string>
</array>

<key>NSLocalNetworkUsageDescription</key>
<string>${PRODUCT_NAME} uses the local network to discover Cast-enabled devices on your WiFi
network.</string>
```

## Usage

List devices:

```
Widget build(BuildContext context) {
  return FutureBuilder<List<CastDevice>>(
    future: CastDiscoveryService().search(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: Text(
            'Error: ${snapshot.error.toString()}',
          ),
        );
      } else if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (snapshot.data!.isEmpty) {
        return Column(
          children: [
            Center(
              child: Text(
                'No Chromecast founded',
              ),
            ),
          ],
        );
      }

      return Column(
        children: snapshot.data!.map((device) {
          return ListTile(
            title: Text(device.name),
            onTap: () {
              _connectToYourApp(context, device);
            },
          );
        }).toList(),
      );
    },
  );
}
```

Connect to device:

```
Future<void> _connect(BuildContext context, CastDevice object) async {
  final session = await CastSessionManager().startSession(object);

  session.stateStream.listen((state) {
    if (state == CastSessionState.connected) {
      _sendMessage(session);
    }
  });

  session.messageStream.listen((message) {
    print('receive message: $message');
  });

  session.sendMessage(CastSession.kNamespaceReceiver, {
    'type': 'LAUNCH',
    'appId': 'YouTube', // set the appId of your app here
  });
}
```

`CastSessionManager` is used to keep track of all sessions.

Send message:

```
void _sendMessage(CastSession session) {
  session.sendMessage('urn:x-cast:namespace-of-the-app', {
    'type': 'sample',
  });
}
```

Except for the launch message, you should wait until the session have a connected state before sending message.

## Note

Some informations about the protocol used https://docs.rs/crate/gcast/0.1.5/source/PROTOCOL.md

    $ pub global activate protoc_plugin
    $ export PATH="$PATH":"$HOME/.pub-cache/bin"
    $ protoc -I=./lib/cast_channel --dart_out=./lib/cast_channel ./lib/cast_channel/cast_channel.proto --plugin "pub run protoc_plugin"

## Author

- [Jonathan VUKOVICH-TRIBOUHARET](https://github.com/jonathantribouharet) 
