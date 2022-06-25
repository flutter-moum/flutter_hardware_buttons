import 'dart:async';

import 'package:flutter/services.dart';

const _VOLUME_BUTTON_CHANNEL_NAME = 'flutter.moum.hardware_buttons.volume';
const _HOME_BUTTON_CHANNEL_NAME = 'flutter.moum.hardware_buttons.home';
const _LOCK_BUTTON_CHANNEL_NAME = 'flutter.moum.hardware_buttons.lock';

const EventChannel _volumeButtonEventChannel =
    EventChannel(_VOLUME_BUTTON_CHANNEL_NAME);
const EventChannel _homeButtonEventChannel =
    EventChannel(_HOME_BUTTON_CHANNEL_NAME);
const EventChannel _lockButtonEventChannel =
    EventChannel(_LOCK_BUTTON_CHANNEL_NAME);

Stream<VolumeButtonEvent>? _volumeButtonEvents;

/// A broadcast stream of volume button events
Stream<VolumeButtonEvent> get volumeButtonEvents {
  if (_volumeButtonEvents == null) {
    _volumeButtonEvents = _volumeButtonEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) => _eventToVolumeButtonEvent(event));
  }
  return _volumeButtonEvents!;
}

Stream<HomeButtonEvent>? _homeButtonEvents;

/// A broadcast stream of home button events
Stream<HomeButtonEvent> get homeButtonEvents {
  if (_homeButtonEvents == null) {
    _homeButtonEvents = _homeButtonEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) => HomeButtonEvent.INSTANCE);
  }
  return _homeButtonEvents!;
}

Stream<LockButtonEvent>? _lockButtonEvents;

/// A broadcast stream of lock button events
Stream<LockButtonEvent> get lockButtonEvents {
  if (_lockButtonEvents == null) {
    _lockButtonEvents = _lockButtonEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) => LockButtonEvent.INSTANCE);
  }
  return _lockButtonEvents!;
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
/// On Android, this gets called immediately after user presses the home button.
/// On iOS, this gets called when user presses the home button and returns to the app.
class HomeButtonEvent {
  static const INSTANCE = HomeButtonEvent();

  const HomeButtonEvent();
}

/// Lock button event
class LockButtonEvent {
  static const INSTANCE = LockButtonEvent();

  const LockButtonEvent();
}
