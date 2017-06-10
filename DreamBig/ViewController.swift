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
    var emojiSize: CGFloat = 200
    @IBOutlet var sceneView: ARSKView!

    var emojiSizeTextView = UITextView()
    var spawnDistanceTextView = UITextView()
    var verticalOffsetTextView = UITextView()
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

        // Position and size the textviews
        let textViewSize = CGSize(width: 200, height: 50)
        let bottomOfScreen = view.frame.maxY
        emojiSizeTextView.frame = CGRect(
            origin: CGPoint(x: 0, y: bottomOfScreen - textViewSize.height * 4),
            size: textViewSize)
        spawnDistanceTextView.frame = CGRect(
            origin: CGPoint(x: 0, y: bottomOfScreen - textViewSize.height * 3),
            size: textViewSize)
        verticalOffsetTextView.frame = CGRect(
            origin: CGPoint(x: 0, y: bottomOfScreen - textViewSize.height * 2),
            size: textViewSize)
        emojiSpacingScaleTextView.frame = CGRect(
            origin: CGPoint(x: 0, y: bottomOfScreen - textViewSize.height * 1),
            size: textViewSize)
        emojiSizeTextView.text = "Emoji size"
        spawnDistanceTextView.text = "Spawn distance"
        verticalOffsetTextView.text = "Vertical offset"
        emojiSpacingScaleTextView.text = "Emoji spacing"
        emojiSizeTextView.delegate = self
        spawnDistanceTextView.delegate = self
        verticalOffsetTextView.delegate = self
        emojiSpacingScaleTextView.delegate = self
        self.view.addSubview(emojiSizeTextView)
        self.view.addSubview(spawnDistanceTextView)
        self.view.addSubview(verticalOffsetTextView)
        self.view.addSubview(emojiSpacingScaleTextView)
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
        labelNode.fontSize = emojiSize
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
        if let verticalOffset = Float(verticalOffsetTextView.text) {
            self.scene?.verticalOffset = verticalOffset
        }
        if let emojiSpacingScale = Float(emojiSpacingScaleTextView.text) {
            self.scene?.emojiSpacingScale = emojiSpacingScale
        }
    }

}
