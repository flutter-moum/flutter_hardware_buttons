# Hardware Button Detection for Flutter

[![Version](https://img.shields.io/pub/v/hardware_buttons.svg)](https://pub.dev/packages/hardware_buttons) ![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)

A Flutter plugin for iOS and Android for detecting various hardware buttons such as volume and home button.


## Features

- Detect volume buttons
- Detect home button
- To be added...



## Installation

To use this plugin, follow the [plugin installation instructions](https://pub.dev/packages/hardware_buttons#-installing-tab-).



## Screenshots

![screenshots](https://user-images.githubusercontent.com/26567846/66265518-14c69900-e853-11e9-8495-8c2966be4e6c.jpg)



## Usage

In order to listen to volume button events, use `volumeButtonEvents.listen` as below:

```
import 'package:hardware_buttons/hardware_buttons.dart'

StreamSubscription _volumeButtonSubscription;

@override
void initState() {
  super.initState();
  _volumeButtonSubscription = volumeButtonEvents.listen((VolumeButtonEvent event) {
    // do something
    // event is either of VolumeButtonEvent.VOLUME_UP or VolumeButtonEvent.VOLUME_DOWN
  });
}

@override
void dispose() {
  super.dispose();
  // be sure to cancel on dispose
  _volumeButtonSubscription?.cancel();
}
```

*Note*
- On iOS, when volume is minimum and user presses volume down button, VOLUME_DOWN event doesn't occur. VOLUME_UP vice versa.
- On the other hand, VOLUME_DOWN and VOLUME_UP events always occur whenever button is pressed on Android.

Similarly, you can listen to home button events using `homeButtonEvents.listen`.
