package flutter.moum.hardware_buttons

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.PluginRegistry


class HardwareButtonsPlugin(
    private var context: Context?,
    private val type: HardwareButtonType
): EventChannel.StreamHandler {
    companion object {
        private const val VOLUME_BUTTON_CHANNEL_NAME = "flutter.moum.hardware_buttons.volume"

        @JvmStatic
        fun registerWith(registrar: PluginRegistry.Registrar) {
            val volumeButtonChannel = EventChannel(registrar.messenger(), VOLUME_BUTTON_CHANNEL_NAME)
            volumeButtonChannel.setStreamHandler(HardwareButtonsPlugin(registrar.context(), HardwareButtonType.VOLUME))
        }
    }

    private var runnable: Runnable? = null

    override fun onListen(args: Any?, events: EventChannel.EventSink?) {
        // 일단 제대로 동작하는지 테스트 용도로 실제 볼륨버튼 이벤트가 아니라 그냥
        // 1초마다 이벤트를 던지는 식으로 구현해봤습니당
        Handler(Looper.getMainLooper()).postDelayed(createTestRunnable(events, 0), 1000)
    }

    private fun createTestRunnable(events: EventChannel.EventSink?, counter: Int): Runnable {
        runnable = Runnable {
            events?.success(counter)
            runnable = null
            Handler(Looper.getMainLooper()).postDelayed(createTestRunnable(events, counter + 1), 1000)
        }
        return runnable!!
    }

    override fun onCancel(args: Any?) {
        runnable?.also { Handler(Looper.getMainLooper()).removeCallbacks(it) }
    }
}

enum class HardwareButtonType {
    VOLUME,
}
