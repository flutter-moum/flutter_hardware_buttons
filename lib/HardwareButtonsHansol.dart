import 'package:flutter/services.dart';

const _VOLUME_BUTTON_CHANNEL_NAME = 'flutter.moum.hardware_buttons.volume';

const EventChannel _volumeButtonEventChannel = EventChannel(_VOLUME_BUTTON_CHANNEL_NAME);

enum VolumeButtonEvent {
  VOLUME_UP,
  VOLUME_DOWN,
}

VolumeButtonEvent _keyCodeToVolumeButtonEvent(dynamic keyCode) {
  if (keyCode == 24) {
    return VolumeButtonEvent.VOLUME_UP;
  } else if (keyCode == 25) {
    return VolumeButtonEvent.VOLUME_DOWN;
  } else {
    throw Exception('Invalid volume button key code');
  }
}

Stream<VolumeButtonEvent> _volumeButtonEvents;
Stream<VolumeButtonEvent> get volumeButtonEvents {
  if (_volumeButtonEvents == null) {
    _volumeButtonEvents = _volumeButtonEventChannel
      .receiveBroadcastStream()
      .map((dynamic keyCode) => _keyCodeToVolumeButtonEvent(keyCode));
  }
  return _volumeButtonEvents;
}
