//
//  DrawingViewController.swift
//  DreamBig
//
//  Created by Andy Cho on 2017-06-13.
//  Copyright © 2017 AcroMace. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController, DrawingImageViewDelegate {

    let emojiBaseSize: CGFloat = 12 // Base font size for the emoji
    var drawingModel: DrawingModel? // Model passed to the AR view controller after drawing
    var currentEmoji = "💩" // The emoji we're using to draw - will be able to change later

    @IBOutlet weak var drawingImageView: DrawingImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        drawingImageView.delegate = self
        drawingModel = DrawingModel(canvasSize: drawingImageView.frame.size)
    }

    func drewEmoji(at point: CGPoint, with size: CGFloat) {
        DispatchQueue.main.async { // Don't block on the touch update calls
            let point = self.createDrawingPoint(at: point, with: size)
            self.drawingModel?.addPoint(point: point)
            self.view.addSubview(self.convertDrawingPointToLabel(drawingPoint: point))
        }
    }

    @IBAction func didPressDoneButton(_ sender: Any) {
        // Trying to edit the "Main" storyboard currently crashes Xcode so the name can't be changed
        // Just use a transition and consolidate the two UIViewControllers to a single storyboard when the next beta comes out
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle(for: ViewController.self))
        guard let mainViewController = mainStoryboard.instantiateInitialViewController() as? ViewController else {
            print("Could not create the Main view controller")
            return
        }
        mainViewController.drawingModel = drawingModel
        navigationController?.pushViewController(mainViewController, animated: true)
    }

    // MARK: - Private methods

    private func createDrawingPoint(at point: CGPoint, with size: CGFloat) -> DrawingPoint {
        return DrawingPoint(x: point.x, y: point.y, size: size, emoji: currentEmoji)
    }

    private func convertDrawingPointToLabel(drawingPoint: DrawingPoint) -> UILabel {
        let emoji = UILabel(frame: CGRect.zero)
        emoji.text = currentEmoji
        emoji.font = UIFont.systemFont(ofSize: emojiBaseSize * drawingPoint.size)
        emoji.sizeToFit()

        // Calculate the coordinates of the emoji so that it's centred underneath the finger or pencil
        let x = drawingPoint.x - emoji.frame.size.width / 2
        let navigationBarHeight = navigationController?.navigationBar.frame.size.height ?? 0
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let y = drawingPoint.y - emoji.frame.size.height / 2 + navigationBarHeight + statusBarHeight
        emoji.frame.origin = CGPoint(x: x, y: y)

        return emoji
    }

}
