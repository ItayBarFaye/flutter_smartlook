package com.Smartlook.Smartlook.flutter_smartlook

import com.smartlook.android.core.api.Session
import com.smartlook.android.core.api.Smartlook
import com.smartlook.android.core.api.Smartlook.Companion.instance
import com.smartlook.android.core.api.User
import com.smartlook.sdk.bridge.BridgeManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel
import java.net.URL
import kotlin.collections.set


/**
 * SmartlookPlugin
 */

object BridgeSingleton {
    var methodChannels = HashMap<BinaryMessenger, MethodChannel>()
    val flutterInterfaceBridge: FlutterBridge = FlutterBridge(methodChannels,true)

    init {
        BridgeManager.bridgeInterfaces += flutterInterfaceBridge
    }
}

class SmartlookPlugin : FlutterPlugin {
    var smartlook: Smartlook = instance
    private val bridgeSingleton = BridgeSingleton

    private fun setupChannel(messenger: BinaryMessenger) {
        bridgeSingleton.methodChannels[messenger] = MethodChannel(messenger, METHOD_CHANNEL_NAME)
        val handler = MethodCallHandlerImpl {
            BridgeSingleton.flutterInterfaceBridge.changeTransitioningState(it)
        }
        bridgeSingleton.methodChannels[messenger]?.setMethodCallHandler(handler)

        EventChannel(messenger, EVENT_CHANNEL_NAME).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, eventSink: EventSink) {
                    smartlook.user.session.listeners += object : Session.Listener {
                        override fun onUrlChanged(url: URL) {
                            eventSink.success(url.toString())
                        }
                    }
                    smartlook.user.listeners += object : User.Listener {
                        override fun onUrlChanged(url: URL) {
                            eventSink.success(url.toString())
                        }
                    }
                }

                override fun onCancel(arguments: Any?) {
                    smartlook.user.listeners.clear()
                    smartlook.user.session.listeners.clear()
                }
            })
    }

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        setupChannel(binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        val binaryMessenger: BinaryMessenger = binding.binaryMessenger
        val methodChannel = bridgeSingleton.methodChannels.remove(binaryMessenger)
        methodChannel?.setMethodCallHandler(null)
    }

    private companion object {
        const val METHOD_CHANNEL_NAME = "smartlook"
        const val EVENT_CHANNEL_NAME = "smartlookEvent"
    }

}