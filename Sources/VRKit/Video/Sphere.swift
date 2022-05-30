import SceneKit
import AVKit

extension SCNSphere {
    convenience init(radius:CGFloat, video:AVPlayer, fov:Int, section:SCNMaterial.VideoSection = .all) {
        let material = SCNMaterial(video: video, section: section)
        material.cullMode = .front
        material.diffuse.wrapS = .clampToBorder
        material.diffuse.wrapT = .clampToBorder
        material.diffuse.contentsTransform = SCNMatrix4Scale(material.diffuse.contentsTransform, -360/Float(fov), 1, 1) //negative scale to flip the image as it is being watched from the inside of the sphere
        material.diffuse.contentsTransform = SCNMatrix4Translate(material.diffuse.contentsTransform, 360 / Float(fov) / 2 + 0.5, 0, 0)
        
        self.init(radius: radius)
        self.segmentCount = 48
        self.firstMaterial = material
    }
}
