package flutter.moum.hardware_buttons

import android.app.Activity
import android.content.Context
import android.graphics.PixelFormat
import android.os.Build
import android.view.KeyEvent
import android.view.View
import android.view.WindowManager
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.PluginRegistry


class HardwareButtonsPlugin(
    private val activity: Activity,
    private val type: HardwareButtonType
): EventChannel.StreamHandler {
    companion object {
        private const val VOLUME_BUTTON_CHANNEL_NAME = "flutter.moum.hardware_buttons.volume"

        @JvmStatic
        fun registerWith(registrar: PluginRegistry.Registrar) {
            val volumeButtonChannel = EventChannel(registrar.messenger(), VOLUME_BUTTON_CHANNEL_NAME)
            volumeButtonChannel.setStreamHandler(HardwareButtonsPlugin(registrar.activity(), HardwareButtonType.VOLUME))
        }
    }

    // todo: 싱글턴으로 만들어야함. 안그러면 HardwareButtonType을 여러개 추가할 때 마다 새로운 windowOverlayView를 추가할테니

    private var keyDetectionView: KeyDetectionView? = null

    // Flutter에서 앱이 종료될 때 onCancel() 콜백을 제대로 안불러주기 때문에 우리가 직접 불러야함
    // related: https://github.com/flutter/plugins/pull/1992/files/04df85fef5a994d93d89b02b27bb7789ec452528#diff-efd825c710217272904545db4b2198e2
    private val lifecycleCallbacks = object: EmptyActivityLifecycleCallbacks() {
        override fun onActivityDestroyed(activity: Activity?) {
            // todo: 파라미터로 넘어온 activity가 우리 activity와 동일한애인지 확인해야함
            this@HardwareButtonsPlugin.activity.application.unregisterActivityLifecycleCallbacks(this)
            onCancel(null)
        }
    }

    init {
        activity.application.registerActivityLifecycleCallbacks(lifecycleCallbacks)
    }

    override fun onListen(args: Any?, eventDispatcher: EventChannel.EventSink?) {
        keyDetectionView = KeyDetectionView(activity, callback = object: KeyDetectionView.KeyCallback {
            override fun onKeyEvent(event: KeyEvent) {
                if (event.action == KeyEvent.ACTION_DOWN) {
                    if (type == HardwareButtonType.VOLUME &&
                        (event.keyCode == KeyEvent.KEYCODE_VOLUME_UP || event.keyCode == KeyEvent.KEYCODE_VOLUME_DOWN)) {
                        eventDispatcher?.success(event.keyCode)
                    }
                }
                activity.dispatchKeyEvent(event)
            }
        })

        addOverlayWindowView(keyDetectionView!!)
    }

    override fun onCancel(args: Any?) {
        keyDetectionView?.run { removeOverlayWindowView(this) }
    }

    private fun addOverlayWindowView(view: View) {
        val windowType = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        else
            WindowManager.LayoutParams.TYPE_SYSTEM_ALERT

        val params = WindowManager.LayoutParams(0, 0,
            windowType,
            WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE,
            PixelFormat.TRANSLUCENT)

        (activity.getSystemService(Context.WINDOW_SERVICE) as WindowManager).addView(view, params)
    }

    private fun removeOverlayWindowView(view: View) {
        (activity.getSystemService(Context.WINDOW_SERVICE) as WindowManager).removeView(view)
    }
}

enum class HardwareButtonType {
    VOLUME,
}
