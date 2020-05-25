import 'package:flutter/material.dart';
import 'package:cast/cast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cast Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    CastDiscoveryService().start();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CastDevice>>(
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
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  Future<void> _connect(BuildContext context, CastDevice object) async {
    final session = await CastSessionManager().startSession(object);

    session.stateStream.listen((state) {
      if (state == CastSessionState.connected) {
        _sendMessage(session);
      }
    });

    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': 'YouTube', // set the appId of your app here
    });
  }

  void _sendMessage(CastSession session) {
    session.sendMessage('urn:x-cast:namespace-of-the-app', {
      'type': 'sample',
    });
  }
}
