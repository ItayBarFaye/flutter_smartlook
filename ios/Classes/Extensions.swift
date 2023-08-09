import Foundation
import SmartlookAnalytics

public extension SmartlookAnalytics.Status {

    func toInt() -> Int {
        switch self {
        case .recording:
            return 0
            
        case .notRecording(Status.Cause.notStarted):
            return 1
            
        case .notRecording(Status.Cause.stopped):
            return 2
            
        case .notRecording(Status.Cause.projectLimitReached):
            return 4 // 4 because one missing compared to android
            
        case .notRecording(Status.Cause.internalError):
            return 6 // 6 because one missing compared to android
            
        default: return 1
        }
    }
}

public extension RenderingMode {
    init(int: Int) {
        switch int {
        case 0:
            self = .noRendering
        case 2:
            self = .wireframe()
                        
        default: self = .native
        }
    }

    func toInt() -> Int {
        let val = self
        switch val {
        case .noRendering: return 0
            
        case .native: return 1
            
            
        case .wireframe: return 2
            
            
        default: return 0
        }
    }
}


public extension Region {
    init(int: Int) {
        switch int {
        case 0:
            self = .eu
        case 1:
            self = .us
                        
        default: self = .eu
        }
    }

    func toInt() -> Int {
        let val = self
        switch val {
        case .eu: return 0
            
        case .us: return 1
            
        default: return 0
        }
    }
}
