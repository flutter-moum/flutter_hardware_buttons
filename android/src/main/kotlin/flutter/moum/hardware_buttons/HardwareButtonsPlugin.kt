package flutter.moum.hardware_buttons

import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.PluginRegistry

class HardwareButtonsPlugin {
    companion object {
        private const val VOLUME_BUTTON_CHANNEL_NAME = "flutter.moum.hardware_buttons.volume"
        private const val HOME_BUTTON_CHANNEL_NAME = "flutter.moum.hardware_buttons.home"
        private const val LOCK_BUTTON_CHANNEL_NAME = "flutter.moum.hardware_buttons.lock"

        @JvmStatic
        fun registerWith(registrar: PluginRegistry.Registrar) {
            val activity = registrar.activity()
            val application = activity.application

            registrar.addActivityResultListener(HardwareButtonsWatcherManager.getInstance(application, activity))

            val volumeButtonChannel = EventChannel(registrar.messenger(), VOLUME_BUTTON_CHANNEL_NAME)
            volumeButtonChannel.setStreamHandler(VolumeButtonStreamHandler(activity))

            val homeButtonChannel = EventChannel(registrar.messenger(), HOME_BUTTON_CHANNEL_NAME)
            homeButtonChannel.setStreamHandler(HomeButtonStreamHandler(activity))

            val lockButtonChannel = EventChannel(registrar.messenger(), LOCK_BUTTON_CHANNEL_NAME)
            lockButtonChannel.setStreamHandler(LockButtonStreamHandler(activity))
        }
    }
}
