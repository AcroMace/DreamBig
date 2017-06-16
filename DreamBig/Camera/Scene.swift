//
//  Scene.swift
//  DreamBig
//
//  Created by Andy Cho on 2017-06-10.
//  Copyright © 2017 AcroMace. All rights reserved.
//

import SpriteKit
import ARKit

class Scene: SKScene {

    var drawingModel: DrawingModel?
    var emojiSpacingScale: Float = 0.5 // spacing between emojis
    var verticalOffset: Float = 0 // m from the ground
    var spawnDistance: Float = 5 // m away from the user
    private(set) var identifierToEmoji = [UUID: String]()

    // On tap, we reset the position of all nodes
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let `drawingModel` = drawingModel {
            resetNodes(drawingModel: drawingModel)
        }
    }

    func resetNodes(drawingModel: DrawingModel) {
        self.removeAllChildren()
        identifierToEmoji = [:]

        // Get the maximum size of an emoji
        let maxSize = (drawingModel.points.max { p1, p2 in p1.size < p2.size })?.size ?? 0
        // Add the emoji nodes to the scene
        for drawingPoint in drawingModel.points {
            addEmojiNode(x: 0.02 * Float(drawingPoint.x - drawingModel.canvasSize.width / 2),
                         y: -0.02 * Float(drawingPoint.y - drawingModel.canvasSize.height / 2),
                         // All emojis are at least 1 meter in front, distance exaggerated by a factor of 10
                         z: 10 * Float(drawingPoint.size - maxSize) - 2,
                         emoji: drawingPoint.emoji)
        }
    }

    // Add an emoji node in the relative coordinate system of the camera
    //  - x is the metres RIGHT from the centre of the screen
    //  - y is the metres UP from the centre of the screen
    //  - z is the metres coming out TOWARDS YOU from the screen
    //  - emoji is the text on the node
    private func addEmojiNode(x: Float, y: Float, z: Float, emoji: String) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        print("Adding node: (\(x),\(y),\(z))")

        // Create anchor using the camera's current position
        if let currentFrame = sceneView.session.currentFrame {
            var translation = matrix_identity_float4x4
            translation.columns.3.x = x
            translation.columns.3.y = y
            translation.columns.3.z = z
            let transform = simd_mul(currentFrame.camera.transform, translation)

            // Add a new anchor to the session
            let anchor = ARAnchor(transform: transform)
            identifierToEmoji[anchor.identifier] = emoji
            sceneView.session.add(anchor: anchor)
        }
    }
}
