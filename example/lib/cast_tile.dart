import 'package:cast/cast.dart';
import 'package:flutter/material.dart';

class CastTile extends StatefulWidget {
  CastTile(this.device);

  final CastDevice device;

  @override
  State<CastTile> createState() => _CastTileState();
}

class _CastTileState extends State<CastTile> {
  CastSession? session;

  @override
  void initState() {
    super.initState();
    initialzeSession();
  }

  initialzeSession() async {
    CastSession sessionTemp =
        await CastSessionManager().startSession(widget.device);
    sessionTemp.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': 'CC1AD845', // set the appId of your app here
    });

    sessionTemp.messageStream.listen((message) {
      print('receive message: $message');

      if (message['type'] == 'RECEIVER_STATUS') {
        final double? volume = message['status']?['volume']?['level'];
        print('Volume is currently $volume');

        final snackBar = SnackBar(content: Text('Volume $volume'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    sessionTemp.stateStream.listen((state) {
      if (state == CastSessionState.connected && session == null) {
        setState(() {
          session = sessionTemp;
        });
      }
    });
  }

  Widget saperator() => SizedBox(width: 10);

  @override
  Widget build(BuildContext context) {
    if (session == null) {
      return Text('Connecting');
    }

    return Row(
      children: [
        saperator(),
        Text(widget.device.name),
        saperator(),
        TextButton(
          onPressed: _playButton,
          child: Text('Play'),
        ),
        saperator(),
        TextButton(
          onPressed: _pauseButton,
          child: Text('Pause'),
        ),
        saperator(),
        TextButton(
          onPressed: _setVolumeToHalf,
          child: Text('Volume to half'),
        ),
        saperator(),
        TextButton(
          onPressed: _playVideo,
          child: Text('Media'),
        ),
        saperator(),
        TextButton(
          onPressed: _connectToYourApp,
          child: Text('YouTube'),
        ),
        saperator(),
      ],
    );
  }

  void _pauseButton() async {
    session!.pause();
  }

  void _playButton() async {
    final session = await CastSessionManager().startSession(widget.device);

    session.messageStream.listen((message) {
      final snackBar = SnackBar(content: Text('Play $message'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
    session.play();
  }

  void _setVolumeToHalf() async {
    session!.setVolume(0.5);
  }

  Future<void> _connectToYourApp() async {
    session!.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': 'Youtube', // set the appId of your app here
    });
  }

  // void _sendMessageToYourApp(CastSession session) {
  void _playVideo() {
    var message = {
      // Here you can plug an URL to any mp4, webm, mp3 or jpg file with the proper contentType.
      'contentId':
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/big_buck_bunny_1080p.mp4',
      'contentType': 'video/mp4',
      'streamType': 'BUFFERED', // or LIVE

      // Title and cover displayed while buffering
      'metadata': {
        'type': 0,
        'metadataType': 0,
        'title': "Big Buck Bunny",
        'images': [
          {
            'url':
                'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg'
          }
        ]
      }
    };

    session!.sendMessage(CastSession.kNamespaceMedia, {
      'type': 'LOAD',
      'autoPlay': true,
      'currentTime': 0,
      'media': message,
    });
  }
}
