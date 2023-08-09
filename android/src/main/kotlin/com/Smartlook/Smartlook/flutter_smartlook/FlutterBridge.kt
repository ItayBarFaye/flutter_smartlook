package com.Smartlook.Smartlook.flutter_smartlook

import android.util.Log
import android.view.View
import com.smartlook.sdk.bridge.model.BridgeFrameworkInfo
import com.smartlook.sdk.bridge.model.BridgeInterface
import com.smartlook.sdk.bridge.model.BridgeWireframe
import io.flutter.embedding.android.FlutterView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class MicroTimer {
    private var startTime: Long = 0L

    fun start() {
        startTime = System.nanoTime()
    }

    fun elapsedMicros(): Long {
        val currentTime = System.nanoTime()
        return (currentTime - startTime) / 1000
    }
}

class FlutterBridge(
    private val methodChannels: HashMap<BinaryMessenger, MethodChannel>,
    override var isRecordingAllowed: Boolean,
) : BridgeInterface {

    private var isDebugMode = false //with false to production
    private val wireframeParser = WireframeDataParser()
    private val classes = listOf(FlutterView::class.java)
    fun changeTransitioningState(state: Boolean) {
        isRecordingAllowed = !state
    }
    override fun obtainFrameworkInfo(callback: (BridgeFrameworkInfo?) -> Unit) {
        callback(
            BridgeFrameworkInfo(
                framework = "FLUTTER",
                frameworkPluginVersion = "4.1.5",
                frameworkVersion = "-"
            )
        )
    }

    override fun obtainWireframeRootClasses(): List<Class<out View>> {
        return classes
    }

    override fun obtainWireframeData(instance: View, callback: (BridgeWireframe?) -> Unit) {
        if (instance !is FlutterView) {
            callback(null)
            return
        }

        val methodChannel = methodChannels[instance.binaryMessenger]

        if (methodChannel == null) {
            callback(null)
            return
        }

        val timer = MicroTimer()
        timer.start()

        methodChannel.invokeMethod(
            "getWireframe", "arg", object : MethodChannel.Result {
                override fun success(result: Any?) {
                    val wireframeMap = result as? HashMap<String, Any>
                    if (wireframeMap == null) {
                        callback(null)
                        return
                    }

                    if (wireframeMap["isTransitioning"] as Boolean? == true) {
                        return
                    }

                    if (isDebugMode) {
                        Log.d("elapsedTime:", "${timer.elapsedMicros()}")
                    }
                    callback(wireframeParser.createBridgeWireframe(instance, wireframeMap))
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    Log.d(
                        "SmartlookPlugin",
                        "Error occured on wireframe, please submit a bug. Or check that you have added SmartlookHelperWidget over your MaterialApp"
                    )
                    callback(null)
                }

                override fun notImplemented() {
                    Log.d(
                        "SmartlookPlugin",
                        "Wireframe not implemented, please check that Smartlook is implemented. If the log persists after start of the app submit a bug."
                    )
                    callback(null)
                }
            })
    }
}