package com.Smartlook.Smartlook.flutter_smartlook

import android.graphics.Color
import android.graphics.Rect
import android.util.SparseArray
import com.smartlook.sdk.bridge.extensions.px
import com.smartlook.sdk.bridge.model.BridgeWireframe
import com.smartlook.sdk.common.datatype.Colors
import com.smartlook.sdk.common.utils.extensions.get
import com.smartlook.sdk.common.utils.extensions.smartlookId
import io.flutter.embedding.android.FlutterView
import io.flutter.plugin.platform.PlatformView
import java.util.*

class WireframeDataParser {
    private val platformViewsCache = WeakHashMap<FlutterView, SparseArray<PlatformView>>()
    fun createBridgeWireframe(
        flutterView: FlutterView,
        wireframeData: HashMap<String, Any>
    ): BridgeWireframe {
        val wireframeViews = viewFromMap(flutterView, wireframeData, false)
        return BridgeWireframe(
            wireframeViews,
            wireframeViews.rect.width(),
            wireframeViews.rect.height()
        )
    }

    private fun rectFromMap(map: HashMap<String, Any>): Rect {
        val left = (map["left"] as Double).toFloat().px
        val top = (map["top"] as Double).toFloat().px
        val width = (map["width"] as Double).toFloat().px
        val height = (map["height"] as Double).toFloat().px

        return Rect(left, top, left + width, top + height)
    }

    private fun skeletonFromMap(
        map: HashMap<String, Any>,
        isTransparent: Boolean,
    ): BridgeWireframe.View.Skeleton {
        val isText = map["isText"] as Boolean? ?: false
        val alpha = (map["opacity"] as Double?)?.toFloat() ?: 1.0F
        return BridgeWireframe.View.Skeleton(
            colors = Colors(Color.parseColor(map["color"] as String)),
            radius = 0,
            type = if (isText) BridgeWireframe.View.Skeleton.Type.TEXT else null,
            rect = rectFromMap(map),
            flags = null,
            isOpaque = alpha == 1.0F && !isTransparent,
        )
    }

    private fun skeletonsFromListOfMap(
        skeletonsMapList: List<HashMap<String, Any>>?,
        isTransparent: Boolean,
    ): List<BridgeWireframe.View.Skeleton>? {
        val skeletonsList: ArrayList<BridgeWireframe.View.Skeleton> = arrayListOf()
        if (skeletonsMapList == null) {
            return null
        }
        for (skeletonMap in skeletonsMapList) {
            skeletonsList.add(skeletonFromMap(skeletonMap, isTransparent))
        }
        return skeletonsList
    }

    private fun viewFromMap(
        flutterView: FlutterView,
        map: HashMap<String, Any>,
        isTransparent: Boolean,
    ): BridgeWireframe.View {
        val skeletonsListMap = map["skeletons"] as List<HashMap<String, Any>>?
        val viewsListMap = map["children"] as List<HashMap<String, Any>>?
        val rect = rectFromMap(map)
        val opacity = (map["opacity"] as Double?)?.toFloat() ?: 1.0F
        val type = map["type"] as String
        val nativeId = map["nativeViewId"]?.let {
            var platformViews = platformViewsCache[flutterView]
            if (platformViews == null) {
                platformViews =
                    flutterView.get<Any>("flutterEngine")?.get<Any>("platformViewsController")
                        ?.get("platformViews")
                platformViewsCache[flutterView] = platformViews
            }
            platformViews?.get(it as Int)?.view?.smartlookId
        }

        return BridgeWireframe.View(
            nativeId ?: map["id"] as String,
            name = type,
            rect = rect,
            type = null,
            typename = type,
            hasFocus = false,
            offset = null,
            alpha = opacity,
            isSensitive = map["isSensitive"] as Boolean? ?: false,
            skeletons = skeletonsFromListOfMap(skeletonsListMap, opacity != 1.0F || isTransparent),
            foregroundSkeletons = null,
            subviews = viewsFromListOfMap(
                flutterView,
                viewsListMap,
                opacity != 1.0F || isTransparent
            )

        )
    }

    private fun viewsFromListOfMap(
        flutterView: FlutterView,
        viewsMapList: List<HashMap<String, Any>>?,
        isTransparent: Boolean,
    ): List<BridgeWireframe.View>? {
        return viewsMapList?.map { viewFromMap(flutterView, it, isTransparent) }
    }
}