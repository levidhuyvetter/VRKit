import UIKit
import CoreMotion
import GeometryKit
import SceneKit

class SCNVRCameraHeadTracker {
    static var shared = SCNVRCameraHeadTracker()
    
    var target:SCNVRCamera?
    
    private var motionManager = CMMotionManager()
    private var orientationObserver:NSObjectProtocol?
    
    private var correction = UIDevice.current.orientation.quaternion
    private var offset:Quaternion<Double>?
    
    private init() {}
    
    func start(target:SCNVRCamera) {
        self.stop()
        
        self.target = target
        
        self.orientationObserver = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: UIDevice.current, queue: .main) { _ in
            if UIDevice.current.orientation.isLandscape {
                self.correction = UIDevice.current.orientation.quaternion
            }
        }
        
        self.motionManager.deviceMotionUpdateInterval = 1.0/60.0
        self.motionManager.startDeviceMotionUpdates(to: .main) { data, error in
            guard let q = data?.attitude.quaternion else { return }
            
            let gyro = Quaternion(x: q.y, y: q.z, z: q.x, w: q.w).normalised
            let corrected = gyro * self.correction
            let offset = self.offset ?? {
                let offset = corrected.decomposed(vector: (0, 1, 0)).twist.inversed
                self.offset = offset
                return offset
            }()
            
            self.target?.orientation = SCNQuaternion(offset * corrected)
        }
    }
    
    func stop() {
        if let observer = self.orientationObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    func calibrate() {
        self.offset = nil
    }
    
    deinit {
        self.stop()
    }
}

extension UIDeviceOrientation {
    var quaternion:Quaternion<Double> {
        switch self {
        case .landscapeLeft: return Quaternion<Double>(degX: -90, degY: 180, degZ: 0)
        default: return Quaternion<Double>(degX: -90, degY: 0, degZ: 0)
        }
    }
}
