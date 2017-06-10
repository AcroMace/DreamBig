//
//  ViewController.swift
//  DreamBig
//
//  Created by Andy Cho on 2017-06-10.
//  Copyright © 2017 AcroMace. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController, ARSKViewDelegate {

    var scene: Scene?
    @IBOutlet var sceneView: ARSKView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true

        // Load the SKScene from 'Scene.sks'
        scene = SKScene(fileNamed: "Scene") as? Scene
        if scene != nil {
            sceneView.presentScene(scene)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSKViewDelegate

    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        guard let emoji = scene?.identifierToEmoji[anchor.identifier] else {
            return nil
        }
        let labelNode = SKLabelNode(text: emoji)
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        labelNode.fontSize = 200
        return labelNode
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user

    }

    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay

    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required

    }
}
