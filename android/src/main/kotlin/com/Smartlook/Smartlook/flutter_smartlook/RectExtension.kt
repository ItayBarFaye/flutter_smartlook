package com.Smartlook.Smartlook.flutter_smartlook

import org.json.JSONObject

internal fun JSONObject.getFloat(name: String): Float {
    return getDouble(name).toFloat()
}