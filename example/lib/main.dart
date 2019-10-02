import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hardware_buttons/hardware_buttons.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  VolumeButtonEvent _currentVolumeButtonEvent;
  StreamSubscription _volumeButtonSubscription;

  @override
  void initState() {
    super.initState();
    _volumeButtonSubscription = volumeButtonEvents.listen((VolumeButtonEvent event) {
      setState(() {
        _currentVolumeButtonEvent = event;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _volumeButtonSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Value: $_currentVolumeButtonEvent\n'),
        ),
      ),
    );
  }

}
