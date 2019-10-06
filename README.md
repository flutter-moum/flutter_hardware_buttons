# Hardware Button Detection for Flutter

[![Version](https://img.shields.io/pub/v/hardware_buttons.svg)](https://pub.dev/packages/hardware_buttons) ![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)

A Flutter plugin for iOS and Android for detecting various hardware buttons such as volume and home button.

// 추가 설명

lifecycle 설명



## Features

- Detect volume buttons
- Detect home button
- To be added...



## Installation

To use this plugin, follow the [plugin installation instructions](https://pub.dev/packages/hardware_buttons#-installing-tab-).



## Screenshot

![screenshots](https://user-images.githubusercontent.com/26567846/66265518-14c69900-e853-11e9-8495-8c2966be4e6c.jpg)



## Example

```dart
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _latestHardwareButtonEvent;

  StreamSubscription<HardwareButtons.VolumeButtonEvent> _volumeButtonSubscription;
  StreamSubscription<HardwareButtons.HomeButtonEvent> _homeButtonSubscription;

  @override
  void initState() {
    super.initState();
    _volumeButtonSubscription = HardwareButtons.volumeButtonEvents.listen((event) {
      setState(() {
        _latestHardwareButtonEvent = event.toString();
      });
    });

    _homeButtonSubscription = HardwareButtons.homeButtonEvents.listen((event) {
      setState(() {
        _latestHardwareButtonEvent = 'HOME_BUTTON';
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _volumeButtonSubscription?.cancel();
    _homeButtonSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Value: $_latestHardwareButtonEvent\n')
            ],
          ),
        ),
      ),
    );
  }

}
```
