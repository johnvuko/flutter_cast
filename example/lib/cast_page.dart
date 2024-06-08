import 'package:cast/cast.dart';
import 'package:flutter/material.dart';

class CastPage extends StatefulWidget {
  @override
  _CastPageState createState() => _CastPageState();
}

class _CastPageState extends State<CastPage> {
  final ChromecastController _controller = ChromecastController();
  final TextEditingController _urlController = TextEditingController(text: "https://moodle1.myyschool.xyz/MXE1MDdTT3dhQUxwZEs2SDF6d2RHOXJFYVJ6NElFNUFVVEd4MjdiQWFWOWNqUDVyTU5aaGpzbnB1QlNoY2s0Rg.m3u8");
  final TextEditingController _startTimeController = TextEditingController(text: "0");
  final TextEditingController _appIdController = TextEditingController(text: "1E79D581");

  @override
  void initState() {
    super.initState();
    _controller.startSearch();
    _controller.currentTimeNotifier.addListener(_updateUI);
    _controller.playerStateNotifier.addListener(_updateUI);
    _controller.devicesNotifier.addListener(_updateUI);
    _controller.standByNotifier.addListener(_handleStandBy);
  }

  @override
  void dispose() {
    _controller.currentTimeNotifier.removeListener(_updateUI);
    _controller.playerStateNotifier.removeListener(_updateUI);
    _controller.devicesNotifier.removeListener(_updateUI);
    _controller.standByNotifier.removeListener(_handleStandBy);
    super.dispose();
  }

  void _updateUI() {
    setState(() {});
  }

  void _handleStandBy() {
    if (_controller.standByNotifier.value) {
      // Handle standBy state, for example, show a notification or pause the app
      print("Chromecast is in standby mode");
    } else {
      print("Chromecast is active");
    }
  }

  void _play(CastDevice device) {
    String appId = _appIdController.text;
    String url = _urlController.text;
    double startTime = double.tryParse(_startTimeController.text) ?? 0.0;
    _controller.connectAndPlayMedia(context, device, appId: appId,url: url, title: "CapRandom", startTime:  startTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChromeCastTest"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_controller.hasError)
              Center(
                child: Text('Error: ${_controller.error}'),
              )
            else if (_controller.devicesNotifier.value.isEmpty)
              Center(
                child: CircularProgressIndicator(),
              )
            else
              Column(
                children: [
                  TextField(
                    controller: _appIdController,
                    decoration: InputDecoration(labelText: "Enter App ID"),
                  ),
                  TextField(
                    controller: _urlController,
                    decoration: InputDecoration(labelText: "Enter Video URL"),
                  ),
                  TextField(
                    controller: _startTimeController,
                    decoration: InputDecoration(labelText: "Enter Start Time (seconds)"),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _controller.devicesNotifier.value.length,
                    itemBuilder: (context, index) {
                      final device = _controller.devicesNotifier.value[index];
                      return ListTile(
                        trailing: IconButton(
                          icon: Icon(Icons.stop_circle),
                          onPressed: _controller.closeSession,
                        ),
                        title: Text(device.name),
                        onTap: () {
                          _play(device);
                        },
                      );
                    },
                  ),
                  Text('Current Time: ${_controller.currentTimeNotifier.value} seconds'),
                  Text('Player State: ${_controller.playerStateNotifier.value}'),
                  Text('StandBy: ${_controller.standByNotifier.value}'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
