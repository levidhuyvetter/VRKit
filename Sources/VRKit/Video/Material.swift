import SceneKit
import SpriteKit
import AVKit

extension SCNMaterial {
    convenience init(video:AVPlayer, section:VideoSection = .all) {
        self.init()
        
        let videoSize = CGSize(width: 5000, height: 2500)
        let videoOrigin = section.videoOrigin(for: videoSize)
        let sceneSize = section.viewPortSize(for: videoSize)
        
        let videoNode = SKVideoNode(avPlayer: video)
        videoNode.size = CGSize(width: videoSize.width, height: -videoSize.height) //negative height as spritekit is upside down when mapped to scenekit
        videoNode.position = videoOrigin
        let spriteScene = SKScene(size: sceneSize)
        spriteScene.addChild(videoNode)
        self.diffuse.contents = spriteScene
        self.lightingModel = .constant
    }
    
    enum VideoSection {
        case all
        case top
        case bottom
        case left
        case right
        
        func videoOrigin(for size:CGSize) -> CGPoint {
            switch self {
            case .all: return CGPoint(x: size.width / 2, y: size.height / 2)
            case .top: return CGPoint(x: size.width / 2, y: 0)
            case .bottom: return CGPoint(x: size.width / 2, y: size.height / 2)
            case .left: return CGPoint(x: size.width / 2, y: size.height / 2)
            case .right: return CGPoint(x: 0, y: size.height / 2)
            }
        }
        
        func viewPortSize(for size:CGSize) -> CGSize {
            switch self {
            case .all: return size
            case .top: return CGSize(width: size.width, height: size.height / 2)
            case .bottom: return CGSize(width: size.width, height: size.height / 2)
            case .left: return CGSize(width: size.width / 2, height: size.height)
            case .right: return CGSize(width: size.width / 2, height: size.height)
            }
        }
    }
}
