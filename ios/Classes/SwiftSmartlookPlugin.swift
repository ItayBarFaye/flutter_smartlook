import EventKit
import Flutter
import SmartlookAnalytics
import UIKit
import Vision
import WebKit
import SwiftUI


public class SwiftSmartlookPlugin: NSObject, FlutterPlugin {
    let smartlook = Smartlook.instance
    var isAfterFirstStart = false
    static var flutterBridge: FlutterBridge?
    static var methodChannels = [String : FlutterMethodChannel]()


    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftSmartlookPlugin()

        let methodChannel = FlutterMethodChannel(name: "smartlook", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        
        flutterBridge = FlutterBridge(channel: methodChannel)
        Smartlook.instance.register(bridgeInterface: flutterBridge!)
        let eventChannel = FlutterEventChannel(name: "smartlookEvent", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(SwiftStreamHandler())
        //here I would register smartlook with messengerId and callback
        
   }

    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any]
        let preferences = smartlook.preferences
        var eventTracking = preferences.eventTracking
        let user = smartlook.user
        let state = smartlook.state
        
        switch call.method {
        case "start":
            smartlook.start()
            if !isAfterFirstStart {
                preferences.useAdaptiveFramerate(false)
                isAfterFirstStart = true
            }
            
        case "stop":
            smartlook.stop()
            
        case "reset":
            smartlook.reset()
            
        case "trackEvent":
            guard let key: String = arguments?["name"] as? String else {
                break
            }
            let properties: Properties? = properties(from: arguments?["properties"] as? [String: String?])
            
            smartlook.track(event: key, properties: properties)
            
        case "trackNavigationEnter":
            guard let key: String = arguments?["name"] as? String else {
                break
            }
            let properties: Properties? = properties(from: arguments?["properties"] as? [String: String?])
        
            smartlook.track(navigationEvent: key, direction: .enter, properties: properties)
            
        case "trackNavigationExit":
            guard let key: String = arguments?["name"] as? String else {
                break
            }
            let properties: Properties? = properties(from: arguments?["properties"] as? [String: String?])
           
            smartlook.track(navigationEvent: key, direction: .exit, properties: properties)
            
        case "putStringEventProperty":
            guard let name: String = arguments?["name"] as? String,
                  let value: String? = arguments?["value"] as? String?
            else {
                break
            }
            
            smartlook.eventProperties[name] = value
            
        case "getStringEventProperty":
            guard let name: String = arguments?["name"] as? String else {
                break
            }
            
            result(smartlook.eventProperties[name])
            return
            
        case "removeEventProperty":
            guard let name: String = arguments?["name"] as? String else {
                break
            }
            
            smartlook.eventProperties[name] = nil
            
        case "clearEventProperties":
            for key in smartlook.eventProperties.keys {
                smartlook.eventProperties[key] = nil
            }
            
        case "setUserIdentifier":
            guard let identifier: String = arguments?["identifier"] as? String else {
                break
            }
            
            user.identifier(identifier)
            
        case "setUserName":
            user.name(arguments?["name"] as? String)
            
        case "setUserEmail":
            user.email(arguments?["email"] as? String)
            
        case "setUserProperty":
            guard let name: String = arguments?["name"] as? String,
                  let value: String? = arguments?["value"] as? String?
            else {
                break
            }
            
            user.setProperty(name, to: value)
            
        case "getUserProperty":
            guard let name: String = arguments?["name"] as? String else {
                break
            }
            
            result(user[name])
            return
            
        case "removeUserPropety":
            guard let name: String = arguments?["name"] as? String else {
                break
            }
            
            user[name] = nil
            
        case "openNew":
            user.openNew()
            
        case "getUserUrl":
            result(user.url?.absoluteString)
            return
            
        case "openNewSession":
            user.session.openNew()
            
        case "getSessionUrl":
            result(user.session.url?.absoluteString)
            return
            
        case "getSessionUrlWithTimeStamp":
            result(user.session.urlWithTimestamp?.absoluteString)
            return
            
        case "setupConfigurationRelayProxyHost":
            smartlook.setupConfiguration?.relayProxyHost(arguments?["relayProxyHost"] as? String)
            
        case "setProjectKey":
            guard let projectKey: String = arguments?["projectKey"] as? String else {
                break
            }
            
            preferences.projectKey(projectKey)
            
        case "setFrameRate":
            preferences.framerate(arguments?["frameRate"] as? Int)
            
        case "getPreferencesFrameRate":
            result(smartlook.preferences.framerate)
            return
            
        case "setRenderingMode":
            guard let renderingModeKey: Int = arguments?["renderingMode"] as? Int else {
                break
            }
            
            preferences.renderingMode(RenderingMode(int: renderingModeKey))
            
        case "setAdaptiveFrameRateEnabled":
            guard let adaptiveStatus = arguments?["adaptiveStatus"] as? Bool else {
                break
            }
            
            preferences.useAdaptiveFramerate(adaptiveStatus)
            
        case "getAdaptiveFrameRateEnabled":
            result(state.usingAdaptiveFramerate)
            return
            
        case "setRecordingMask":
            guard let maskList = arguments?["maskList"] as? String? else {
                break
            }
            
            setRecordingMask(json: maskList, result: { result(nil) })
            
        case "changePlatformClassSensitivity":
            guard let sensitivityElements = arguments?["sensitivity"] as? [[Int]] else {
                break
            }
                for sensitivityTuple in sensitivityElements {
                    let classId = sensitivityTuple[0]
                    let isSensitive = sensitivityTuple[1]
                    if let classType = convertSensitivityEnumToClass(sensitivityEnum: classId) {
                        smartlook.sensitivity[classType] = isSensitive == 1
                                              
                    }
                }
            
        case "setEventTrackingInteractionUserStatus":
            guard let track = arguments?["track"] as? Bool else {
                break
            }
            
            eventTracking?.trackUserInteraction = track
            
        case "setEventTrackingInteractionRageClickStatus":
            guard let rageClick = arguments?["rageClick"] as? Bool else {
                break
            }
            
            eventTracking?.trackRageClicks = rageClick
            
        case "eventTrackingEnableAll":
            preferences.eventTracking = EventTracking()
            
        case "eventTrackingDisableAll":
            preferences.eventTracking = EventTracking.noTracking
            
        case "restoreDefault":
            smartlook.preferences.eventTracking = EventTracking.default
            
        case "getRecordingStatus":
            let status = smartlook.state.status
            result(status.toInt())
            return
            
        case "isRecording":
            result(smartlook.state.status == .recording)
            return
            
        case "getProjectKey":
            result(smartlook.state.projectKey)
            return
            
        case "getStateFrameRate":
            result(smartlook.state.framerate)
            return
            
        case "getRenderingMode":
            let renderingMode = smartlook.state.renderingMode
            result(renderingMode.toInt())
            return
            
        case "setRegion":
            guard let region = arguments?["region"] as? Int else {
                break
            }
            smartlook.setupConfiguration = SetupConfiguration()
            smartlook.setupConfiguration?.region = Region(int: region)
            
            
        case "getRegion":
            result(smartlook.setupConfiguration?.region?.toInt())
            return
            
        case "changeTransitioningState":
            guard let isTransitioning = arguments?["transitioningState"] as? Bool else {
                break
            }
            SwiftSmartlookPlugin.flutterBridge?.recordingAllowed = !isTransitioning
            
        // only for Android
        case "enableLogs": break
            
        case "getSurfaceCaptureEnabled":
            result(false)
            return
            
        case "setSurfaceCaptureEnabled": break
        default:
            result(FlutterMethodNotImplemented)
            return
        }
        
        result(nil)
    }
    
    private func setRecordingMask(json: String?, result: () -> Void) {
        guard let maskListJsonVal = json else {
            Smartlook.instance.recordingMask = nil
            result()
            return
        }

        guard let recordingMaskListData = try? JSONDecoder().decode([RecordingMaskElement].self, from: Data(maskListJsonVal.utf8)) else {
            result()
            return
        }
        
        var recordingMaskList: [MaskElement] = Array()
        for mask in recordingMaskListData {
            recordingMaskList.append(
                MaskElement(
                    rect: mask.rect.cgRect(),
                    type: mask.isCovering ? .covering : .erasing)
            )
        }
        Smartlook.instance.recordingMask = RecordingMask(elements: recordingMaskList)
    }
    
    private func convertSensitivityEnumToClass(sensitivityEnum: Int) -> UIView.Type? {
        switch sensitivityEnum {
        case 2:
            return UITextView.self
        case 3:
            return UITextField.self
        case 4:
            return WKWebView.self
        default:
            return nil
        }
    }
    
    private func properties(from dictionary: [String: String?]?) -> Properties? {
        guard let dictionary = dictionary else {
            return nil
        }
        
        let properties = Properties()
        for (key, value) in dictionary {
            properties[key] = value
        }
        
        return properties
    }
}

struct RecordingMaskElement: Decodable {
    let rect: Rect
    let isCovering: Bool
    enum CodingKeys: String, CodingKey {
        case rect
        case isCovering
    }

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        isCovering = try rootContainer.decode(Bool.self, forKey: .isCovering)
        rect = try rootContainer.decode(Rect.self, forKey: .rect)
    }
}

extension Rect {
    func cgRect() -> CGRect {
        return CGRect(x: left, y: top, width: width , height: height)
    }
}

struct Rect: Decodable {
    let left: Int
    let top: Int
    let width: Int
    let height: Int
    enum RectCodingKeys: String, CodingKey {
        case left
        case top
        case width
        case height
    }

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RectCodingKeys.self)
        left = try rootContainer.decode(Int.self, forKey: .left)
        top = try rootContainer.decode(Int.self, forKey: .top)
        width = try rootContainer.decode(Int.self, forKey: .width)
        height = try rootContainer.decode(Int.self, forKey: .height)
    }
}
