import Foundation
import SmartlookAnalytics

class SwiftStreamHandler: NSObject, FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        NotificationCenter.default.addObserver(forName: User.urlDidChangeNotification, object: nil, queue: nil) { _ in
            events(Smartlook.instance.user.url?.absoluteString)
        }
        NotificationCenter.default.addObserver(forName: Session.urlDidChangeNotification, object: nil, queue: nil) { _ in
            events(Smartlook.instance.user.session.url?.absoluteString)
        }
        
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
