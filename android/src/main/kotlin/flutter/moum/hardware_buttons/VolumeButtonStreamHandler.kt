package flutter.moum.hardware_buttons

import android.app.Activity
import io.flutter.plugin.common.EventChannel


class VolumeButtonStreamHandler(private val activity: Activity): EventChannel.StreamHandler {
    private val application = activity.application
    private var streamSink: EventChannel.EventSink? = null

    private val volumeButtonListener = object: HardwareButtonsWatcherManager.VolumeButtonListener {
        override fun onVolumeButtonEvent(event: HardwareButtonsWatcherManager.VolumeButtonEvent) {
            streamSink?.success(event.value)
        }
    }

    override fun onListen(args: Any?, sink: EventChannel.EventSink?) {
        this.streamSink = sink
        HardwareButtonsWatcherManager.getInstance(application, activity).addVolumeButtonListener(volumeButtonListener)
    }

    // this function doesn't actually get called by flutter framework as of now: 2019/10/02
    override fun onCancel(args: Any?) {
        this.streamSink = null
        HardwareButtonsWatcherManager.getInstance(application, activity).removeVolumeButtonListener(volumeButtonListener)
    }
}