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

    var emojiSpacingScale: Float = 0.5 // spacing between emojis
    var verticalOffset: Float = 0 // m from the ground
    var spawnDistance: Float = 5 // m away from the user
    var identifierToEmoji = [UUID: String]()

    let rows = 10
    let columns = 21
    let grid = "☁️☁️  ☁️☁️☁️ ☁️☁️☁️ ☁️☁️☁️ ☁️☁️ ☁️☁️" +
               "☁️ ☁️ ☁️ ☁️ ☁️  ️ ☁️ ☁️ ☁️ ☁️ ☁️" +
               "☁️ ☁️ ☁️☁️  ☁️☁️☁️ ☁️☁️☁️ ☁️ ☁️ ☁️" +
               "☁️ ☁️ ☁️ ☁️ ☁️   ☁️ ☁️ ☁️ ☁️ ☁️" +
               "☁️☁️  ☁️ ☁️ ☁️☁️☁️ ☁️ ☁️ ☁️ ☁️ ☁️" +
               "     🙌🙌🙌 🙌🙌🙌 🙌🙌🙌     " +
               "     🙌 🙌  🙌  🙌       " +
               "     🙌🙌   🙌  🙌🙌🙌     " +
               "     🙌 🙌  🙌  🙌 🙌     " +
               "     🙌🙌🙌 🙌🙌🙌 🙌🙌🙌     "

    override func didMove(to view: SKView) {
        // Setup your scene here
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeAllChildren()

        guard grid.count == rows * columns else {
            print("The grid count was \(grid.count) but expected \(rows * columns) characters")
            return
        }
        for (index, emoji) in grid.enumerated() {
            addPoint(x: 0.5 * (Float(index % columns) - Float(columns / 2)),
                     y: 0.5 * (Float(rows / 2) - Float(index / columns)) + Float(verticalOffset),
                     z: Float(-spawnDistance),
                     emoji: emoji)
        }
    }

    func addPoint(x: Float, y: Float, z: Float, emoji: Character) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }

        // Create anchor using the camera's current position
        if let currentFrame = sceneView.session.currentFrame {

            // Create a transform with a translation of 0.2 meters in front of the camera
            var translation = matrix_identity_float4x4
            translation.columns.3.x = x
            translation.columns.3.y = y
            translation.columns.3.z = z
            let transform = simd_mul(currentFrame.camera.transform, translation)

            // Add a new anchor to the session
            let anchor = ARAnchor(transform: transform)
            identifierToEmoji[anchor.identifier] = String(emoji)
            sceneView.session.add(anchor: anchor)
        }
    }
}
