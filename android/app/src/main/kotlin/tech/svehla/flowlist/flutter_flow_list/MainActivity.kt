package tech.svehla.flowlist.flutter_flow_list

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import android.view.WindowManager
import android.view.ViewTreeObserver

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        getWindow().setStatusBarColor(0x00000000)
        GeneratedPluginRegistrant.registerWith(this)
        //Remove full screen flag after load
        val viewTreeObserver = getFlutterView().getViewTreeObserver()
        viewTreeObserver.addOnGlobalLayoutListener(object : ViewTreeObserver.OnGlobalLayoutListener {
            override fun onGlobalLayout() {
                getFlutterView().getViewTreeObserver().removeOnGlobalLayoutListener(this)
                getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
            }
        })
    }
}
