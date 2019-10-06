import 'dart:async';

import 'package:flutter/services.dart';

const _VOLUME_BUTTON_CHANNEL_NAME = 'flutter.moum.hardware_buttons.volume';
const _HOME_BUTTON_CHANNEL_NAME = 'flutter.moum.hardware_buttons.home';

const EventChannel _volumeButtonEventChannel =
    EventChannel(_VOLUME_BUTTON_CHANNEL_NAME);
const EventChannel _homeButtonEventChannel =
    EventChannel(_HOME_BUTTON_CHANNEL_NAME);

Stream<VolumeButtonEvent> _volumeButtonEvents;
/// A broadcast stream of events of volume button
Stream<VolumeButtonEvent> get volumeButtonEvents {
  if (_volumeButtonEvents == null) {
    _volumeButtonEvents = _volumeButtonEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) => _eventToVolumeButtonEvent(event));
  }
  return _volumeButtonEvents;
}

Stream<HomeButtonEvent> _homeButtonEvents;
/// A broadcast stream of events of home button
Stream<HomeButtonEvent> get homeButtonEvents {
  if (_homeButtonEvents == null) {
    _homeButtonEvents = _homeButtonEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) => HomeButtonEvent.INSTANCE);
  }
  return _homeButtonEvents;
}

/// Volume button events
/// Applies both to device and earphone buttons
enum VolumeButtonEvent {

  /// Volume Up button event
  VOLUME_UP,

  /// Volume Down button event
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

/// Home button event
/// On Android, this gets called immediately when user presses the home button.
/// On iOS, this gets called when user presses the home button and returns to the app.
class HomeButtonEvent {
  static const INSTANCE = HomeButtonEvent();

  const HomeButtonEvent();
}
