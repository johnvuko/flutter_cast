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
  final double volumeChangeValue = 0.1;

  Widget saperator() => const SizedBox(width: 10);

  @override
  Widget build(BuildContext context) {
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
            onPressed: () async {
              final double? volume = await widget.device.getVolume();
              final snackBar = SnackBar(content: Text('Volume: $volume'));
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: const Text('Get Volume'),
          ),
          saperator(),
          TextButton(
            onPressed: () => widget.device.volumeUp(volumeChangeValue),
            child: const Text('Volume Up'),
          ),
          saperator(),
          TextButton(
            onPressed: () => widget.device.volumeDown(volumeChangeValue),
            child: const Text('Volume Down'),
          ),
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
            onPressed: _openPLEX,
            child: const Text('PLEX'),
          ),
          saperator(),
        ],
      ),
    );
  }

  void _openPLEX() async {
    widget.device.sendSingleRequestBefore(
      CastSession.kNamespaceReceiver,
      'LAUNCH',
      payload: {
        'appId': '9AC194DC', // PLEX app ID for Chromecast
      },
      close: false,
    );
  }

  // TODO: YouTube chromecast support is deprecated I think the new one is youtube-remote
  // void _openYoutubeVideoAndPlay(String videoId) async {
  //   await session?.close();
  //   session = await CastSessionManager().startSession(widget.device);

  //   session!.sendMessage(CastSession.kNamespaceReceiver, {
  //     'type': 'LAUNCH',
  //     'appId': '233637DE', // YouTube app ID for Chromecast
  //   });

  //   await Future.delayed(const Duration(seconds: 20));

  //   session!.sendMessage(CastSession.kNamespaceMedia, {
  //     'type': 'LOAD',
  //     'media': {
  //       'contentId': 'https://www.youtube.com/watch?v=$videoId',
  //       'contentType': 'video/mp4',
  //       'streamType': 'BUFFERED',
  //     },
  //     // 'requestId': 1, // Use a unique requestId for each command
  //   });
  // }
}
