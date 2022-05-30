import SceneKit

public protocol SCNVRCamera:AnyObject {
    var leftEye:SCNNode { get }
    var rightEye:SCNNode { get }
    var orientation:SCNQuaternion { get set }
}

extension SCNVRCamera {
    var fov:Float {
        get {
            if #available(iOS 11.0, *) {
                return Float(self.leftEye.camera?.fieldOfView ?? 0)
            } else {
                return Float(self.leftEye.camera?.xFov ?? 0)
            }
        } set {
            if #available(iOS 11.0, *) {
                self.leftEye.camera?.fieldOfView = CGFloat(newValue)
                self.rightEye.camera?.fieldOfView = CGFloat(newValue)
            } else {
                self.leftEye.camera?.xFov = Double(newValue)
                self.rightEye.camera?.xFov = Double(newValue)
            }
        }
    }
    
    var enableHeadTracking:Bool {
        get {
            return SCNVRCameraHeadTracker.shared.target === self
        } set {
            if newValue {
                SCNVRCameraHeadTracker.shared.start(target: self)
            } else if SCNVRCameraHeadTracker.shared.target === self {
                SCNVRCameraHeadTracker.shared.stop()
            }
        }
    }
    
    func centre() {
        if self.enableHeadTracking {
            SCNVRCameraHeadTracker.shared.calibrate()
        }
    }
    
    fileprivate func setUpCameras(fov:Float) {
        let leftCamera = SCNCamera()
        let rightCamera = SCNCamera()
        
        leftCamera.zNear = 0.001
        rightCamera.zNear = 0.001
        
        if #available(iOS 11.0, *) {
            leftCamera.projectionDirection = .horizontal
            rightCamera.projectionDirection = .horizontal
            leftCamera.fieldOfView = CGFloat(fov)
            rightCamera.fieldOfView = CGFloat(fov)
        } else {
            leftCamera.xFov = Double(fov)
            rightCamera.xFov = Double(fov)
        }
        
        self.leftEye.camera = leftCamera
        self.rightEye.camera = rightCamera
    }
}

class SCNVRCameraNode:SCNNode, SCNVRCamera {
    let leftEye:SCNNode = SCNNode()
    let rightEye:SCNNode = SCNNode()
    
    var ipd:Float {
        didSet {
            self.leftEye.position = SCNVector3(-self.ipd / 2, 0, 0)
            self.rightEye.position = SCNVector3(self.ipd / 2, 0, 0)
        }
    }
    
    init(fov:Float = 75.0, ipd:Float = 0.064) {
        self.ipd = ipd
        
        super.init()
        
        self.leftEye.position = SCNVector3(-self.ipd / 2, 0, 0)
        self.rightEye.position = SCNVector3(self.ipd / 2, 0, 0)
        
        self.setUpCameras(fov: fov)
        
        self.addChildNode(self.leftEye)
        self.addChildNode(self.rightEye)
        
        self.enableHeadTracking = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SCNVRCameras:SCNVRCamera {
    let leftEye = SCNNode()
    let rightEye = SCNNode()
    
    var orientation:SCNQuaternion {
        get {
            self.leftEye.orientation
        } set {
            self.leftEye.orientation = newValue
            self.rightEye.orientation = newValue
        }
    }
    
    init(fov:Float = 75.0) {
        self.setUpCameras(fov: fov)
        self.enableHeadTracking = true
    }
}
