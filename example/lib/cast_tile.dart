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

    sessionTemp.stateStream.listen((state) {
      if (state == CastSessionState.connected && session == null) {
        setState(() {
          session = sessionTemp;
        });
      }
    });
    sessionTemp.getStatus();
  }

  Widget saperator() => const SizedBox(width: 10);

  @override
  Widget build(BuildContext context) {
    // if (session == null) {
    //   return const Text('Connecting');
    // }

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
            // onPressed: _playVideo,
            onPressed: () {
              widget.device.openMedia(
                url:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/big_buck_bunny_1080p.mp4',
                title: 'Big Buck Bunny',
                coverImage:
                    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg',
              );
            },
            child: const Text('Media'),
          ),
          saperator(),
          TextButton(
            onPressed: () => widget.device.setVolume(0.2),
            child: const Text('volume 0.2'),
          ),
          // saperator(),
          // TextButton(
          //   onPressed: () => _openYoutubeVideoAndPlay('o5owbiQahnY'),
          //   child: const Text('YouTube'),
          // ),
          saperator(),
          TextButton(
            onPressed: _openPLEX,
            child: const Text('PLEX'),
          ),
          saperator(),
        ],
      ),
    );
  }

  void _openPLEX() async {
    await session?.close();
    session = await CastSessionManager().startSession(widget.device);

    session!.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': '9AC194DC', // PLEX app ID for Chromecast
    });

    Future.delayed(const Duration(seconds: 20)).then((x) async {
      await session?.close();
    });
  }

  // TODO: Not working, YouTube stack on logo, wrong appId?
  void _openYoutubeVideoAndPlay(String videoId) async {
    await session?.close();
    session = await CastSessionManager().startSession(widget.device);

    session!.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': '233637DE', // YouTube app ID for Chromecast
    });

    await Future.delayed(const Duration(seconds: 20));

    session!.sendMessage(CastSession.kNamespaceMedia, {
      'type': 'LOAD',
      'media': {
        'contentId': 'https://www.youtube.com/watch?v=$videoId',
        'contentType': 'video/mp4',
        'streamType': 'BUFFERED',
      },
      // 'requestId': 1, // Use a unique requestId for each command
    });
  }
}
