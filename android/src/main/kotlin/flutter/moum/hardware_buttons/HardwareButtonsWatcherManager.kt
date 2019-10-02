package flutter.moum.hardware_buttons

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Application
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.PixelFormat
import android.os.Build
import android.util.AttributeSet
import android.view.KeyEvent
import android.view.View
import android.view.WindowManager


// singleton object for managing various resources related with getting hardware button events.
// those who need to listen to any hardware button events add listener to this single instance.
// e.g. HardwareButtonsWatcherManager.getInstance(application, activity).addVolumeButtonListener(volumeButtonListener)
@SuppressLint("StaticFieldLeak")
object HardwareButtonsWatcherManager {
    interface VolumeButtonListener {
        fun onVolumeButtonEvent(event: VolumeButtonEvent)
    }
    enum class VolumeButtonEvent(val value: Int) {
        VOLUME_UP(24),
        VOLUME_DOWN(25),
    }

    interface HomeButtonListener {
        fun onHomeButtonEvent()
    }

    private var application: Application? = null
    private var currentActivity: Activity? = null
    private var activityLifecycleCallbacks: Application.ActivityLifecycleCallbacks? = null

    private var keyWatcher: KeyWatcher? = null
    private var volumeButtonListeners: ArrayList<VolumeButtonListener> = arrayListOf()

    private var homeButtonWatcher: HomeButtonWatcher? = null
    private var homeButtonListeners: ArrayList<HomeButtonListener> = arrayListOf()

    fun getInstance(application: Application, activity: Activity): HardwareButtonsWatcherManager {
        this.application = application
        // set currentActivity to activity only when ActivityLifecycleCallbacks wasn't registered yet.
        // otherwise, currentActivity will be updated in ActivityLifecycleCallbacks.
        if (activityLifecycleCallbacks == null) {
            currentActivity = activity
        }
        registerActivityLifecycleCallbacksIfNeeded()
        return this
    }

    private fun registerActivityLifecycleCallbacksIfNeeded() {
        if (activityLifecycleCallbacks == null) {
            activityLifecycleCallbacks = object: EmptyActivityLifecycleCallbacks() {
                override fun onActivityStarted(activity: Activity?) {
                    currentActivity = activity

                    // attach necessary watchers
                    attachKeyWatcherIfNeeded()
                    attachHomeButtonWatcherIfNeeded()
                }

                override fun onActivityStopped(activity: Activity?) {
                    if (currentActivity?.equals(activity) == true) {
                        // detach all watchers
                        detachKeyWatcher()
                        detachHomeButtonWatcher()
                    }
                }

                override fun onActivityDestroyed(activity: Activity?) {
                    if (currentActivity?.equals(activity) == true) {
                        currentActivity = null

                        // remove all listeners and detach all watchers
                        // When flutter app finishes, it doesn't invoke StreamHandler's onCancel() callback properly, so
                        // we should manually clean up resources (i.e. listeners) when activity state becomes invalid (in order to avoid memory leak).
                        // related: https://github.com/flutter/plugins/pull/1992/files/04df85fef5a994d93d89b02b27bb7789ec452528#diff-efd825c710217272904545db4b2198e2
                        volumeButtonListeners.clear()
                        homeButtonListeners.clear()
                        detachKeyWatcher()
                        detachHomeButtonWatcher()
                    }
                }
            }
            application?.registerActivityLifecycleCallbacks(activityLifecycleCallbacks)
        }
    }

    fun addVolumeButtonListener(listener: VolumeButtonListener) {
        if (!volumeButtonListeners.contains(listener)) {
            volumeButtonListeners.add(listener)
        }
        attachKeyWatcherIfNeeded()
    }

    fun addHomeButtonListener(listener: HomeButtonListener) {
        if (!homeButtonListeners.contains(listener)) {
            homeButtonListeners.add(listener)
        }
        attachHomeButtonWatcherIfNeeded()
    }

    fun removeVolumeButtonListener(listener: VolumeButtonListener) {
        volumeButtonListeners.remove(listener)
        if (volumeButtonListeners.size == 0) {
            detachKeyWatcher()
        }
    }

    fun removeHomeButtonListener(listener: HomeButtonListener) {
        homeButtonListeners.remove(listener)
        if (homeButtonListeners.size == 0) {
            detachHomeButtonWatcher()
        }
    }

    private fun attachKeyWatcherIfNeeded() {
        val application = application ?: return
        if (volumeButtonListeners.size > 0 && keyWatcher == null) {
            keyWatcher = KeyWatcher(application.applicationContext, callback = {
                dispatchVolumeButtonEvent(it)
                currentActivity?.dispatchKeyEvent(it)
            })
            addOverlayWindowView(application, keyWatcher!!)
        }
    }

    private fun attachHomeButtonWatcherIfNeeded() {
        val application = application ?: return
        if (homeButtonListeners.size > 0 && homeButtonWatcher == null) {
            homeButtonWatcher = HomeButtonWatcher {
                dispatchHomeButtonEvent()
            }
            val intentFilter = IntentFilter(Intent.ACTION_CLOSE_SYSTEM_DIALOGS)
            application.registerReceiver(homeButtonWatcher, intentFilter)
        }
    }

    private fun detachKeyWatcher() {
        val application = application ?: return
        val keyWatcher = keyWatcher ?: return
        removeOverlayWindowView(application, keyWatcher)
        this.keyWatcher = null
    }

    private fun detachHomeButtonWatcher() {
        val application = application ?: return
        val homeButtonWatcher = homeButtonWatcher ?: return
        application.unregisterReceiver(homeButtonWatcher)
        this.homeButtonWatcher = null
    }

    private fun dispatchVolumeButtonEvent(keyEvent: KeyEvent) {
        if (keyEvent.action == KeyEvent.ACTION_DOWN) {
            val volumeButtonEvent = when (keyEvent.keyCode) {
                KeyEvent.KEYCODE_VOLUME_UP -> VolumeButtonEvent.VOLUME_UP
                KeyEvent.KEYCODE_VOLUME_DOWN -> VolumeButtonEvent.VOLUME_DOWN
                else -> null
            }
            if (volumeButtonEvent != null) {
                for (listener in volumeButtonListeners) {
                    listener.onVolumeButtonEvent(volumeButtonEvent)
                }
            }
        }
    }

    private fun dispatchHomeButtonEvent() {
        for (listener in homeButtonListeners) {
            listener.onHomeButtonEvent()
        }
    }

    private fun addOverlayWindowView(context: Context, view: View) {
        val windowType = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        else
            WindowManager.LayoutParams.TYPE_SYSTEM_ALERT

        val params = WindowManager.LayoutParams(0, 0,
            windowType,
            WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE,
            PixelFormat.TRANSLUCENT)

        (context.getSystemService(Context.WINDOW_SERVICE) as WindowManager).addView(view, params)
    }

    private fun removeOverlayWindowView(context: Context, view: View) {
        (context.getSystemService(Context.WINDOW_SERVICE) as WindowManager).removeView(view)
    }
}

// simple view just to override dispatchKeyEvent
private class KeyWatcher @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0,
    private val callback: ((event: KeyEvent) -> Unit)? = null
) : View(context, attrs, defStyleAttr) {
    override fun dispatchKeyEvent(event: KeyEvent): Boolean {
        callback?.invoke(event)
        return false
    }
}

private class HomeButtonWatcher(private val callback: () -> Unit): BroadcastReceiver() {
    companion object {
        const val KEY_REASON = "reason"
        const val REASON_HOME_KEY = "homekey"
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        val intent = intent ?: return
        if (intent.action == Intent.ACTION_CLOSE_SYSTEM_DIALOGS) {
            if (intent.getStringExtra(KEY_REASON) == REASON_HOME_KEY) {
                callback()
            }
        }
    }
}