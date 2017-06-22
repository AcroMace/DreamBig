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
    var emojiSpacingScale: Float = 1 // spacing between emojis
    var spawnDistance: Float = 1 // m away from the user
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

        // Translate a coordinate position to an angle
        let posToAngleConstant = 0.0003 * Float.pi * emojiSpacingScale
        // Get the maximum size of an emoji
        let maxSize = (drawingModel.points.max { p1, p2 in p1.size < p2.size })?.size ?? 0
        // Add the emoji nodes to the scene
        for drawingPoint in drawingModel.points {
            addEmojiNode(x: posToAngleConstant * Float(drawingPoint.x - drawingModel.canvasSize.width / 2),
                         // For the position, y increases as it goes down
                         y: posToAngleConstant * Float(drawingModel.canvasSize.height / 2 - drawingPoint.y),
                         // All emojis are at least 1 meter in front, distance exaggerated by a factor of 10
                         z: Float(drawingPoint.size - maxSize) - spawnDistance,
                         emoji: drawingPoint.emoji)
        }
    }

    // Add an emoji node in the relative coordinate system of the camera
    //  - x is the angle RIGHT from the centre of the screen
    //  - y is the angle UP from the centre of the screen
    //  - z is the metres coming out TOWARDS YOU from the screen
    //  - emoji is the text on the node
    private func addEmojiNode(x: Float, y: Float, z: Float, emoji: String) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        print("Adding node: (\(x),\(y),\(z))")

        // Create anchor using the camera's current position
        // Important note in case implementation changes later:
        //   The angles for rotation are based on portrait mode (positive is right, up)
        //   The translations are based on landscape mode where the home button is on the right
        //   (positive is to the home button to go right, right side of the iPad to go up)
        if let currentFrame = sceneView.session.currentFrame {
            // Rotate the emoji - directions based on assuming we are in landscape right mode
            // If this was portrait mode, it would be (x, 1, 0, 0), (y, 0, 1, 0) as expected
            let horizontalRotation = matrix_float4x4(SCNMatrix4MakeRotation(x, 0, -1, 0))
            let verticalRotation = matrix_float4x4(SCNMatrix4MakeRotation(y, 1, 0, 0))
            let rotation = simd_mul(horizontalRotation, verticalRotation)

            // Translate the emoji
            var translation = matrix_identity_float4x4
            translation.columns.3.z = z

            // Transform the emoji around the current camera direction
            // Note that the order of the multiplications matter here
            let transform = simd_mul(currentFrame.camera.transform, simd_mul(rotation, translation))

            // Add a new anchor to the session
            let anchor = ARAnchor(transform: transform)
            identifierToEmoji[anchor.identifier] = emoji
            sceneView.session.add(anchor: anchor)
        }
    }

}
