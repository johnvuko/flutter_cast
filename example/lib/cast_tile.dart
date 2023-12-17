import 'package:cast/cast.dart';
import 'package:cast_example/core/utils.dart';
import 'package:flutter/material.dart';

class CastTile extends StatefulWidget {
  const CastTile(this.device, {super.key});

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

    sessionTemp.messageStream.listen((message) {
      logger.t('receive message: $message');

      if (message['type'] == 'RECEIVER_STATUS') {
        final double? volume = message['status']?['volume']?['level'];
        logger.i('Recived status Volume=$volume');
      }
    });

    setState(() {
      session = sessionTemp;
    });
  }

  Widget saperator() => const SizedBox(width: 10);

  @override
  Widget build(BuildContext context) {
    if (session == null) {
      return const Text('Connecting');
    }

    return SizedBox(
      height: 50,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          saperator(),
          Text(widget.device.name),
          saperator(),
          TextButton(
            onPressed: widget.device.playButton,
            child: const Text('Play'),
          ),
          saperator(),
          TextButton(
            onPressed: widget.device.pauseButton,
            child: const Text('Pause'),
          ),
          saperator(),
          TextButton(
            onPressed: _playVideo,
            child: const Text('Media'),
          ),
          saperator(),
          TextButton(
            onPressed: _connectToYourApp,
            child: const Text('YouTube'),
          ),
          saperator(),
          TextButton(
            onPressed: () => widget.device.setVolume(0.2),
            child: const Text('volume 0.2 '),
          ),
          saperator(),
        ],
      ),
    );
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
