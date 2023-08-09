import Flutter
import Foundation
import SmartlookAnalytics

class FlutterBridge: NSObject, BridgeInterface {
    var recordingAllowed: Bool
    
    var frameworkInfo: SmartlookAnalytics.FrameworkInfo?
    var isDebugMode: Bool = false
    
    let channel: FlutterMethodChannel
    init(channel: FlutterMethodChannel) {
        self.recordingAllowed = true
        self.channel = channel
        self.frameworkInfo = FrameworkInfo()
        self.frameworkInfo!.frameworkVersion = "-"
        self.frameworkInfo!.framework = "FLUTTER"
        self.frameworkInfo!.frameworkPluginVersion = "4.1.5"
    }
    
    func obtainFrameworkInfo(completion: @escaping (FrameworkInfo?) -> Void) {
        completion(self.frameworkInfo)
    }


    func obtainWireframeRootClasses(completion: @escaping ([String]) -> Void) {
        let rootClassNames = ["FlutterView"]
        completion(rootClassNames)
    }

    func obtainWireframeData(identifier: Any?,completion: @escaping (BridgeWireframe?) -> Void) {
        let startTime = DispatchTime.now()
        channel.invokeMethod("getWireframe", arguments: "arg"){ (result) in
            guard
                let response = result as? Dictionary<String, Any?>
            else {
                print("Error: Invalid response type")
                completion(nil)
                return
            }
            let rootView = self.viewFromMap(map:response)
            let bridgeWireframe = BridgeWireframe(root: rootView, width: rootView.rect.width, height: rootView.rect.height)
           
            if(self.isDebugMode)
            {
                let endTime = DispatchTime.now()
                let elapsedTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
                let elapsedTimeMicroseconds = elapsedTime / 1000
                print("Time elapsed: \(elapsedTimeMicroseconds) microseconds")
            }
            completion(bridgeWireframe)
        }
    }

    func rectFromMap(_ map: Dictionary<String, Any>) -> CGRect {
        return CGRect(
            x: (map["left"] as! Double),
            y: (map["top"] as! Double),
            width: (map["width"] as! Double),
            height: (map["height"] as! Double)
        )
    }

    func viewFromMap(map: Dictionary<String, Any?>) -> BridgeWireframeView {

        let skeletonMaps = map["skeletons"] as? [Dictionary<String, Any?>]
        let skeletons:[BridgeWireframeSkeleton]? = skeletonMaps == nil ? nil:skeletonsFromListOfMap(skeletonMaps!)
        let childrenMaps = map["children"] as? [Dictionary<String, Any?>]
        let subviews:[BridgeWireframeView]? =  childrenMaps == nil ?nil: viewsFromListOfMap(childrenMaps!)
        let type = map["type"] as! String
        let opacity =  map["opacity"] as? Double ?? 1.0
        let rect = rectFromMap(map as Dictionary<String, Any>)
        let bridgeView = BridgeWireframeView(
            id: map["id"] as! String,
            typeName: type,
            type: .undefined,
            rect: rectFromMap(map as Dictionary<String, Any>),
            alpha: opacity,
            sensitive: map["isSensitive"] as? Bool ?? false,
            skeletons: skeletons
        )
        bridgeView.subviews = subviews
        return bridgeView
    }

    func viewsFromListOfMap(_ viewsMapList: [Dictionary<String, Any?>]) -> [BridgeWireframeView] {
        var viewsList = [BridgeWireframeView]()
        for viewMap in viewsMapList {
            viewsList.append(viewFromMap(map:viewMap))

        }
        return viewsList
    }


    func skeletonFromMap(_ map: Dictionary<String, Any?>) -> BridgeWireframeSkeleton {
        let skeleton = BridgeWireframeSkeleton(
            type: (map["isText"] as? Bool)==true ? .text : .undefined,
            rect: rectFromMap(map as Dictionary<String, Any>),
            radius: 0,
            alpha: map["opacity"] as? Double ?? 1.0,
            color: (map["color"] as! String),
            flags: nil
        )
        return skeleton
    }


    func skeletonsFromListOfMap(_ skeletonsMapList: [Dictionary<String, Any?>]) -> [BridgeWireframeSkeleton] {
        var skeletonsList = [BridgeWireframeSkeleton]()
        for skeletonMap in skeletonsMapList {
            skeletonsList.append(skeletonFromMap(skeletonMap))
        }
        return skeletonsList
    }
}
