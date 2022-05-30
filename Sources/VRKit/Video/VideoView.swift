//
//  File.swift
//  
//
//  Created by Levi Dhuyvetter on 30/05/2022.
//

import SwiftUI

@available(iOS 15.0, *)
extension VRSceneView {
    init(video:URL, projection:SCNVRVideoScene.Projection = .cinema) {
        let scene = SCNVRVideoScene(video: video, projection: projection)
        self.init(scene: scene, camera: scene.camera)
    }
}
