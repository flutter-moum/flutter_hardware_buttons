import 'dart:async';

import 'package:flutter/services.dart';

const _VOLUME_BUTTON_CHANNEL_NAME = 'flutter.moum.hardware_buttons.volume';

const EventChannel _volumeButtonEventChannel = EventChannel(_VOLUME_BUTTON_CHANNEL_NAME);

Stream<VolumeButtonEvent> _volumeButtonEvents;
Stream<VolumeButtonEvent> get volumeButtonEvents {
  if (_volumeButtonEvents == null) {
    _volumeButtonEvents = _volumeButtonEventChannel
      .receiveBroadcastStream()
      .map((dynamic event) => _eventToVolumeButtonEvent(event));
  }
  return _volumeButtonEvents;
}

enum VolumeButtonEvent {
  VOLUME_UP,
  VOLUME_DOWN,
}

VolumeButtonEvent _eventToVolumeButtonEvent(dynamic event) {
  if (event == 24) {
    return VolumeButtonEvent.VOLUME_UP;
  } else if (event == 25) {
    return VolumeButtonEvent.VOLUME_DOWN;
  } else {
    throw Exception('Invalid volume button event');
  }
}

