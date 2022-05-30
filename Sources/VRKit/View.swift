import SwiftUI
import SceneKit

@available(iOS 15.0, *)
struct VRSceneView:View {
    var scene:SCNScene
    var camera:SCNVRCamera
    var hud = HUD()
    
    init(scene:SCNScene, camera:SCNVRCamera? = nil) {
        self.scene = scene
        
        if let camera = camera {
            self.camera = camera
        } else {
            let camera = SCNVRCameraNode()
            camera.position = SCNVector3(0, 1.7, 0)
            scene.rootNode.addChildNode(camera)
            self.camera = camera
        }
    }
    
    var body: some View {
        HStack(spacing:5) {
            SceneView(
                scene: self.scene,
                pointOfView: self.camera.leftEye,
                options: []
            ).overlay {
                self.hud
            }
                        
            SceneView(
                scene: self.scene,
                pointOfView: self.camera.rightEye,
                options: []
            ).overlay {
                self.hud
            }
        }.foregroundColor(.black).statusBar(hidden: true).onTapGesture {
            self.camera.centre()
        }
    }
    
    struct HUD:View {
        var body: some View {
            EmptyView()
        }
    }
}
