package flutter.moum.hardware_buttons

import android.app.Activity
import io.flutter.plugin.common.EventChannel


class HomeButtonStreamHandler(private val activity: Activity): EventChannel.StreamHandler {
    private val application = activity.application
    private var streamSink: EventChannel.EventSink? = null

    private val homeButtonListener = object: HardwareButtonsWatcherManager.HomeButtonListener {
        override fun onHomeButtonEvent() {
            streamSink?.success(0)
        }
    }

    override fun onListen(args: Any?, sink: EventChannel.EventSink?) {
        this.streamSink = sink
        HardwareButtonsWatcherManager.getInstance(application, activity).addHomeButtonListener(homeButtonListener)
    }

    override fun onCancel(args: Any?) {
        this.streamSink = null
        HardwareButtonsWatcherManager.getInstance(application, activity).removeHomeButtonListener(homeButtonListener)
    }
}