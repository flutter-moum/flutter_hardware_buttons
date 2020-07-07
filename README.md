# DEPRECATED

This plugin is deprecated :( We're no longer able to maintain it. 

# hardware_buttons

[![Version](https://img.shields.io/pub/v/hardware_buttons.svg)](https://pub.dev/packages/hardware_buttons) ![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)

A Flutter plugin for iOS and Android for detecting various hardware buttons.

Note: This plugin is still under development, and some APIs might not be available yet. [Feedback](https://github.com/flutter-moum/flutter_hardware_buttons/issues) and [Pull Requests](https://github.com/flutter-moum/flutter_hardware_buttons/pulls) are most welcome!

## Screenshots

![screenshots](https://user-images.githubusercontent.com/26567846/66265518-14c69900-e853-11e9-8495-8c2966be4e6c.jpg)

## Features

- Detect volume buttons
- Detect home button
- Detect lock(power) button
- To be added...

## Android specification

- If you subscribe to volume button events, this plugin will inevitably request for [ACTION_MANAGER_OVERLAY_PERMISSION](https://developer.android.com/reference/android/provider/Settings.html#ACTION_MANAGE_OVERLAY_PERMISSION), since we found out this was the only way to do it well in Flutter Plugin environment. We do show permission request window for you, so there's nothing you should do other than subscribing to the event channel. However, since users may be surprised why your app needs this permission, we suggest notifying users beforehand why this permission will be requested.
- **Migrated to AndroidX as of version ```1.0.0```**. To use with original support libraries, use version ```0.2.4```. Note, however, pre-AndroidX will no longer be supported.

## iOS specification

- No VOLUME_DOWN events are emitted when the volume is already at its minimum. VOLUME_UP events vice versa. On the other hand, events always occur whenever user presses the button on Android.

## Usage

### Import the package

To use this plugin, follow the [plugin installation instructions](https://pub.dev/packages/hardware_buttons#-installing-tab-).

To use with AndroidX, install the latest version as above instructions. To use with original support libraries, install version ```0.2.4``` instead.

## Use the plugin

Add the following import to your Dart code:

```dart
import 'package:hardware_buttons/hardware_buttons.dart';
```

In order to listen to volume button events, use `volumeButtonEvents.listen` as below:

```dart
StreamSubscription _volumeButtonSubscription;

@override
void initState() {
  super.initState();
  _volumeButtonSubscription = volumeButtonEvents.listen((VolumeButtonEvent event) {
    // do something
    // event is either VolumeButtonEvent.VOLUME_UP or VolumeButtonEvent.VOLUME_DOWN
  });
}

@override
void dispose() {
  super.dispose();
  // be sure to cancel on dispose
  _volumeButtonSubscription?.cancel();
}
```

Besides volume button events, there are also:
1. Home button events, via `homeButtonEvents.listen`.
2. Lock button events, via `lockButtonEvents.listen`.

## Example

Find the example wiring in the [example app](https://github.com/flutter-moum/flutter_hardware_buttons/blob/master/example/lib/main.dart).

## API details

See the [hardware_buttons.dart](https://github.com/flutter-moum/flutter_hardware_buttons/blob/master/lib/hardware_buttons.dart) for more API details.

## Issues and feedback

Please file [issues](https://github.com/flutter-moum/flutter_hardware_buttons/issues) to send feedback or report a bug. Thank you!
