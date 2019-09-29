
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hardware_buttons/HardwareButtonsHansol.dart';

class HansolExample extends StatefulWidget {
  @override
  _HansolExampleState createState() => _HansolExampleState();
}

class _HansolExampleState extends State<HansolExample> {
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
