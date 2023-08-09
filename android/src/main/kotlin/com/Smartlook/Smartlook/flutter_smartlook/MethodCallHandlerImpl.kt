package com.Smartlook.Smartlook.flutter_smartlook


import android.graphics.Rect
import android.view.View
import android.webkit.WebView
import android.widget.EditText
import com.smartlook.android.core.api.Preferences
import com.smartlook.android.core.api.Smartlook
import com.smartlook.android.core.api.enumeration.Region
import com.smartlook.android.core.api.enumeration.Status
import com.smartlook.android.core.api.model.Properties
import com.smartlook.android.core.api.model.RecordingMask
import com.smartlook.android.core.api.model.Referrer
import com.smartlook.android.core.video.annotation.RenderingMode
import com.smartlook.sdk.bridge.extensions.px
import com.smartlook.sdk.log.LogAspect
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import org.json.JSONArray

internal class MethodCallHandlerImpl(val onTransitionChanged :(Boolean) -> Unit ) : MethodCallHandler {
    private val smartlook: Smartlook = Smartlook.instance
    private val preferences = smartlook.preferences
    private val eventTracking: Preferences.EventTracking = preferences.eventTracking
    private val user = smartlook.user
    private val state = smartlook.state
    private val intToEnum: Map<Int, Region> = mapOf(
        0 to Region.EU,
        1 to Region.US,
    )
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "start" -> {
                smartlook.start()
            }
            "stop" -> smartlook.stop()
            "reset" -> smartlook.reset()
            "trackEvent" -> {
                val propertiesMap = call.argument<HashMap<String, String?>?>("properties")
                val properties: Properties? = propertiesFromMap(propertiesMap)
                smartlook.trackEvent((call.argument<String>("name"))!!, properties)
            }
            "trackNavigationEnter" -> {
                val propertiesMap = call.argument<HashMap<String, String?>?>("properties")
                val properties: Properties? = propertiesFromMap(propertiesMap)
                smartlook.trackNavigationEnter((call.argument<String>("name"))!!, properties)
            }
            "trackNavigationExit" -> {
                val propertiesMap = call.argument<HashMap<String, String?>?>("properties")
                val properties: Properties? = propertiesFromMap(propertiesMap)
                smartlook.trackNavigationExit((call.argument<String>("name"))!!, properties)
            }
            "setReferrer" -> {
                val referrerObject = Referrer(
                    (call.argument<String>("referrer"))!!,
                    (call.argument<String>("source"))!!
                )
                smartlook.referrer = referrerObject
            }
            "putStringEventProperty" -> {
                smartlook.eventProperties.putString(
                    (call.argument<String>("name"))!!,
                    call.argument<String>("value")
                )
            }
            "getStringEventProperty" -> {
                result.success(smartlook.eventProperties.getString((call.argument<String>("name"))!!))
                return
            }
            "removeEventProperty" -> {
                smartlook.eventProperties.remove((call.argument<String>("name"))!!)
            }
            "clearEventProperties" -> {
                smartlook.eventProperties.clear()
            }
            "setUserIdentifier" -> user.identifier = call.argument<String>("identifier")
            "setUserName" -> user.name = call.argument<String>("name")
            "setUserEmail" -> user.email = call.argument<String>("email")
            "setUserProperty" -> user.properties.putString(
                (call.argument<String>("name"))!!,
                call.argument<String>("value")
            )
            "getUserProperty" -> {
                result.success(user.properties.getString((call.argument<String>("name"))!!))
                return
            }
            "removeUserProperty" -> {
                user.properties.remove((call.argument<String>("name"))!!)
            }
            "openNew" -> {
                user.openNew()
            }
            "getUserUrl" -> {
                result.success(user.url?.toString())
                return
            }
            "openNewSession" -> user.session.openNew()
            "getSessionUrl" -> {
                result.success(user.session.url?.toString())
                return
            }
            "getSessionUrlWithTimeStamp" -> {
                result.success(user.session.urlWithTimestamp?.toString())
                return
            }
            "setRelayProxyHost" -> smartlook.setupConfiguration.relayProxyHost =
                call.argument<Any>("relayProxyHost") as String?
            "setProjectKey" -> preferences.projectKey = call.argument<String>("projectKey")
            "setFrameRate" -> preferences.frameRate = call.argument<Int>("frameRate")
            "getPreferencesFrameRate" -> {
                result.success(smartlook.preferences.frameRate)
                return
            }
            "setRenderingMode" -> {
                val renderingModeValue = call.argument<Int>("renderingMode")!!
                val renderingMode: RenderingMode =
                    convertRenderingModeEnumToClass(renderingModeValue)

                preferences.renderingMode = renderingMode
            }
            "setRecordingMask" -> {
                setRecordingMask(call.argument<String?>("maskList")) { result.success(null) }
            }
            "changePlatformClassSensitivity" -> {
                changePlatformClassSensitivity(call.argument<List<List<Int>>>("sensitivity"))
            }
            "eventTrackingEnableAll" -> eventTracking.enableAll()
            "eventTrackingDisableAll" -> eventTracking.disableAll()
            "eventTrackingNavigationDisableAll" -> eventTracking.navigation.disableAll()
            "setEventTrackingNavigationEnableAll" -> eventTracking.navigation.enableAll()
            "setEventTrackingNavigationActivityStatus" -> eventTracking.navigation.isActivityEnabled =
                call.argument<Boolean>("navigationActivity")!!
            "setEventTrackingNavigationFragmentStatus" -> eventTracking.navigation.isFragmentEnabled =
                call.argument<Boolean>("fragmentStatus")!!
            "setEventTrackingInteractionEnableAll" -> eventTracking.interaction.enableAll()
            "setEventTrackingInteractionDisableAll" -> eventTracking.interaction.disableAll()
            "setEventTrackingInteractionUserStatus" -> {
                val enabledUserTracking = call.argument<Boolean>("track")!!
                eventTracking.interaction.isSelectorEnabled = enabledUserTracking
                eventTracking.interaction.isTouchEnabled = enabledUserTracking
            }
            "setEventTrackingInteractionRageClickStatus" -> {
                eventTracking.interaction.isRageClickEnabled =
                    call.argument<Boolean>("rageClick")!!
            }
            "restoreDefault" -> eventTracking.default()
            "getRecordingStatus" -> {
                val status = smartlook.state.status
                result.success(if (status.isRecording) 0 else (status as Status.NotRecording).cause.ordinal + 1)
                return
            }
            "isRecording" -> {
                val status = state.status
                result.success(status.isRecording)
                return
            }
            "getProjectKey" -> {
                result.success(smartlook.state.projectKey)
                return
            }
            "getStateFrameRate" -> {
                result.success(smartlook.state.frameRate)
                return
            }
            "getRenderingMode" -> {
                result.success(smartlook.state.renderingMode.ordinal)
                return
            }
            "setRegion" -> {
                val region : Int = call.argument<Int>("region")!!
                smartlook.setupConfiguration.region = regionFromInt(region)
            }
            "getRegion" -> {
                result.success(smartlook.setupConfiguration.region?.ordinal)
                return
            }
            "enableLogs" -> smartlook.log.allowedLogAspects = LogAspect.ALL
            "changeTransitioningState" -> {
                val transitioningState = call.argument<Boolean>("transitioningState")!!
                onTransitionChanged(transitioningState)
            }
            else -> {
                result.notImplemented()
                return
            }
        }
        result.success(null)
    }

   private fun regionFromInt(value: Int): Region? = intToEnum[value]

    private fun changePlatformClassSensitivity(sensitivityElements: List<List<Int>>?) {
        if (sensitivityElements != null) {
            for (sensitivityTuple in sensitivityElements) {
                val classId: Int = sensitivityTuple[0]
                val isSensitive: Int = sensitivityTuple[1]
                val classType = convertNativeSensitivityEnumToClass(classId) ?: continue
                classType?.run {
                    smartlook.sensitivity.setViewClassSensitivity(classType, isSensitive == 1)
                }
            }
        }
    }

    private fun setRecordingMask(maskListJson: String?, resultSuccess: () -> Unit) {
        if (maskListJson == null) {
            Smartlook.instance.recordingMask = null
            resultSuccess()
            return
        }

        val jsonArray = JSONArray(maskListJson)

        val recordingMaskList = ArrayList<RecordingMask.Element>(jsonArray.length())

        for (i in 0 until jsonArray.length()) {
            val jsonObject = jsonArray.getJSONObject(i)
            val rect = jsonObject.getJSONObject("rect")
            val isCovering = jsonObject.getBoolean("isCovering")
            val left = rect.getFloat("left").px
            val top = rect.getFloat("top").px
            val width = rect.getFloat("width").px
            val height = rect.getFloat("height").px
            recordingMaskList += RecordingMask.Element(
                Rect(left, top, left + width, top + height),
                if (isCovering) RecordingMask.Element.Type.COVERING
                else RecordingMask.Element.Type.ERASING
            )
        }
        Smartlook.instance.recordingMask = RecordingMask(recordingMaskList)
    }

    private fun convertRenderingModeEnumToClass(renderingModeValue: Int): RenderingMode {
        return if (renderingModeValue == 0) RenderingMode.NO_RENDERING else if (renderingModeValue == 1) RenderingMode.NATIVE else RenderingMode.WIREFRAME
    }

    private fun convertNativeSensitivityEnumToClass(sensitivityEnum: Int): Class<out View>? {
        return when (sensitivityEnum) {
            0 -> EditText::class.java
            1 -> WebView::class.java
            else -> {
                null
            }
        }
    }

    private fun propertiesFromMap(propertiesMap: HashMap<String, String?>?): Properties? {
        if (propertiesMap != null) {
            val properties = Properties()
            for ((key, value) in propertiesMap) {
                properties.putString(key, value)
            }
            return properties
        }
        return null
    }
}