package tech.phoenixtechs.mfmsyndrome

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle;
import android.view.WindowManager.LayoutParams
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugins.GeneratedPluginRegistrant;
import android.content.Context
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.provider.Settings
import java.lang.reflect.Method
import android.net.wifi.WifiManager
import android.content.IntentFilter









class MainActivity: FlutterActivity() {
    private val CHANNEL = "flutter.native/helper"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        window.addFlags(LayoutParams.FLAG_SECURE)
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "isDevMode") {
                result.success(Settings.Secure.getInt(this.contentResolver,
                    Settings.Secure.DEVELOPMENT_SETTINGS_ENABLED, 0) != 0)
            }else if (call.method == "isHotspotOn") {
                val isHotspot: Boolean =false
                val wifimanager: WifiManager = this.getSystemService(Context.WIFI_SERVICE) as WifiManager
                try {
                    val method: Method = wifimanager.javaClass.getDeclaredMethod("isWifiApEnabled")
                    method.setAccessible(true)
                    result.success(method.invoke(wifimanager))
                } catch (ignored: Throwable) {
                    result.success(isHotspot)
                }
            }else if(call.method == "isUSBConnected"){
                intent = this.registerReceiver(null, IntentFilter("android.hardware.usb.action.USB_STATE"))
                result.success(intent.getExtras()?.getBoolean("connected"))
            } else {
                result.notImplemented()
            }
        }
    }
}
