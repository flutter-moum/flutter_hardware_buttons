package flutter.moum.hardware_buttons

import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.PluginRegistry

class HardwareButtonsPlugin {
    companion object {
        private const val VOLUME_BUTTON_CHANNEL_NAME = "flutter.moum.hardware_buttons.volume"

        @JvmStatic
        fun registerWith(registrar: PluginRegistry.Registrar) {
            val volumeButtonChannel = EventChannel(registrar.messenger(), VOLUME_BUTTON_CHANNEL_NAME)
            volumeButtonChannel.setStreamHandler(VolumeButtonStreamHandler(registrar.activity()))
        }
    }
}
