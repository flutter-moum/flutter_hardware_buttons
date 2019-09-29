import 'package:flutter/services.dart';

const _VOLUME_BUTTON_CHANNEL_NAME = 'flutter.moum.hardware_buttons.volume';

const EventChannel _volumeButtonEventChannel = EventChannel(_VOLUME_BUTTON_CHANNEL_NAME);

class VolumeButtonEvent {
  final int value;

  VolumeButtonEvent(this.value);
}

Stream<VolumeButtonEvent> _volumeButtonEvents;
Stream<VolumeButtonEvent> get volumeButtonEvents {
  if (_volumeButtonEvents == null) {
    _volumeButtonEvents = _volumeButtonEventChannel
      .receiveBroadcastStream()
      .map((dynamic event) => VolumeButtonEvent(event));
  }
  return _volumeButtonEvents;
}
