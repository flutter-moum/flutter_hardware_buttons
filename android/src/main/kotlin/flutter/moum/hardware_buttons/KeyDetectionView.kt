package flutter.moum.hardware_buttons

import android.content.Context
import android.util.AttributeSet
import android.view.KeyEvent
import android.view.View


class KeyDetectionView @JvmOverloads constructor(
    context: Context,
    private val callback: KeyCallback,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : View(context, attrs, defStyleAttr) {

    interface KeyCallback {
        fun onKeyEvent(event: KeyEvent)
    }

    override fun dispatchKeyEvent(event: KeyEvent): Boolean {
        callback.onKeyEvent(event)
        return false
    }

}