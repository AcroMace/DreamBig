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

class ViewController: UIViewController {

    var scene: Scene?
    var drawingModel: DrawingModel?
    var emojiSize: CGFloat = 32
    @IBOutlet var sceneView: ARSKView!

    var emojiSizeTextView = UITextView()
    var spawnDistanceTextView = UITextView()
    var emojiSpacingScaleTextView = UITextView()

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
        scene?.drawingModel = drawingModel
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

    private func addControls() {
        // Position and size the textviews
        let textViewSize = CGSize(width: 200, height: 50)
        let bottomOfScreen = view.frame.maxY
        emojiSizeTextView.frame = CGRect(
            origin: CGPoint(x: 0, y: bottomOfScreen - textViewSize.height * 3),
            size: textViewSize)
        spawnDistanceTextView.frame = CGRect(
            origin: CGPoint(x: 0, y: bottomOfScreen - textViewSize.height * 2),
            size: textViewSize)
        emojiSpacingScaleTextView.frame = CGRect(
            origin: CGPoint(x: 0, y: bottomOfScreen - textViewSize.height * 1),
            size: textViewSize)
        emojiSizeTextView.text = "Emoji size"
        spawnDistanceTextView.text = "Spawn distance"
        emojiSpacingScaleTextView.text = "Emoji spacing"
        emojiSizeTextView.delegate = self
        spawnDistanceTextView.delegate = self
        emojiSpacingScaleTextView.delegate = self
        self.view.addSubview(emojiSizeTextView)
        self.view.addSubview(spawnDistanceTextView)
        self.view.addSubview(emojiSpacingScaleTextView)
    }

}

// MARK: - ARSKViewDelegate

extension ViewController: ARSKViewDelegate {

    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        guard let emoji = scene?.identifierToEmoji[anchor.identifier] else {
            return nil
        }
        let labelNode = SKLabelNode(text: emoji)
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        labelNode.fontSize = emojiSize
        return labelNode
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        let alertController = UIAlertController(title: "AR session failed", message: error.localizedDescription, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }

    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print("SESSION INTERRUPTED")
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        print("SESSION INTERRUPTION ENDED")
    }

}

// MARK: - UITextViewDelegate

extension ViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if let emojiSize = Float(emojiSizeTextView.text) {
            self.emojiSize = CGFloat(emojiSize)
        }
        if let spawnDistance = Float(spawnDistanceTextView.text) {
            self.scene?.spawnDistance = spawnDistance
        }
        if let emojiSpacingScale = Float(emojiSpacingScaleTextView.text) {
            self.scene?.emojiSpacingScale = emojiSpacingScale
        }
    }

}
