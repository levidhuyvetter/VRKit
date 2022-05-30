import SceneKit
import AVKit

class SCNVRVideoScene:SCNScene {
    let player:AVPlayer
    var camera:SCNVRCamera
    
    init(video:URL, projection:Projection) {
        self.player = AVPlayer(url: video)
        
        switch projection {
        case .tb(fov: let fov):
            let camera = SCNVRCameras()
            camera.leftEye.position = SCNVector3(x: -45, y: 0, z: 0)
            camera.rightEye.position = SCNVector3(x: 45, y: 0, z: 0)
            
            let leftSphereNode = SCNNode(geometry: SCNSphere(radius: 40, video: self.player, fov: fov, section: .top))
            let rightSphereNode = SCNNode(geometry: SCNSphere(radius: 40, video: self.player, fov: fov, section: .bottom))
            
            leftSphereNode.position = SCNVector3(-45, 0, 0)
            rightSphereNode.position = SCNVector3(45, 0, 0)
            leftSphereNode.eulerAngles = SCNVector3(x: 0, y: .pi, z: 0)
            rightSphereNode.eulerAngles = SCNVector3(x: 0, y: .pi, z: 0)
            
            self.camera = camera
            super.init()
            
            self.rootNode.addChildNode(camera.leftEye)
            self.rootNode.addChildNode(camera.rightEye)
            self.rootNode.addChildNode(leftSphereNode)
            self.rootNode.addChildNode(rightSphereNode)
            
            self.player.play()
        case .sbs(fov: let fov):
            let camera = SCNVRCameras()
            camera.leftEye.position = SCNVector3(x: -45, y: 0, z: 0)
            camera.rightEye.position = SCNVector3(x: 45, y: 0, z: 0)
            
            let leftSphereNode = SCNNode(geometry: SCNSphere(radius: 40, video: self.player, fov: fov, section: .left))
            let rightSphereNode = SCNNode(geometry: SCNSphere(radius: 40, video: self.player, fov: fov, section: .right))
            
            leftSphereNode.position = SCNVector3(-45, 0, 0)
            rightSphereNode.position = SCNVector3(45, 0, 0)
            leftSphereNode.eulerAngles = SCNVector3(x: 0, y: .pi, z: 0)
            rightSphereNode.eulerAngles = SCNVector3(x: 0, y: .pi, z: 0)
            
            self.camera = camera
            super.init()
            
            self.rootNode.addChildNode(camera.leftEye)
            self.rootNode.addChildNode(camera.rightEye)
            self.rootNode.addChildNode(leftSphereNode)
            self.rootNode.addChildNode(rightSphereNode)
            
            self.player.play()
        case .equirectangular(fov: let fov):
            let camera = SCNVRCameraNode()
            
            let sphereNode = SCNNode(geometry: SCNSphere(radius: 40, video: self.player, fov: fov))
            sphereNode.eulerAngles = SCNVector3(x: 0, y: .pi, z: 0)
            
            self.camera = camera
            super.init()
            
            self.rootNode.addChildNode(camera)
            self.rootNode.addChildNode(sphereNode)
            
            self.player.play()
        case .eac:
            fatalError("eac projection has not been implemented")
        case .cinema:
            let camera = SCNVRCameraNode()
            let material = SCNMaterial(video: self.player)
            
            self.camera = camera
            super.init()
            let cinema = SCNScene(named: "Scenes.scnassets/Cinema.scn")!
            self.rootNode.addChildNode(cinema.rootNode)
            //super.init(named: "Scenes.scnassets/Cinema.scn")!
            
            self.rootNode.addChildNode(camera)
            let screenNode = self.rootNode.childNode(withName: "screen", recursively: true)
            screenNode?.geometry?.firstMaterial = material
            
            self.player.play()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Projection {
        case tb(fov:Int)
        case sbs(fov:Int)
        case equirectangular(fov:Int)
        case eac
        case cinema
    }
}
