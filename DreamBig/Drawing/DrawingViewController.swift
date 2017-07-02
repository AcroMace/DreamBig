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

    // Emoji palette view controllers
    var emojiPaletteContainer: UINavigationController?
    var emojiPaletteViewController: EmojiPaletteTableViewController?

    @IBOutlet weak var drawingImageView: DrawingImageView!
    @IBOutlet weak var emojiButton: UIBarButtonItem!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // We need to ensure that the drawingImageView has been expanded
        // before we can get its size
        guard drawingModel == nil else { return }
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

    @IBAction func didPressEmojisButton(_ sender: Any) {
        guard let emojiPaletteContainer = getEmojiPaletteContainer() else {
            return
        }
        present(emojiPaletteContainer, animated: true, completion: nil)
        emojiPaletteContainer.popoverPresentationController?.barButtonItem = emojiButton
    }

    @IBAction func didPressDoneButton(_ sender: Any) {
        // Trying to edit the "Main" storyboard currently crashes Xcode so the name can't be changed
        // Just use a transition and consolidate the two UIViewControllers to a single storyboard when the next beta comes out
        let mainStoryboard = UIStoryboard(name: "CameraViewController", bundle: Bundle(for: CameraViewController.self))
        guard let mainViewController = mainStoryboard.instantiateInitialViewController() as? CameraViewController else {
            print("Could not create the Main view controller")
            return
        }
        mainViewController.drawingModel = drawingModel
        navigationController?.pushViewController(mainViewController, animated: true)
    }

    @IBAction func didPressClearButton(_ sender: Any) {
        drawingModel?.clearPoints()
        for subview in view.subviews {
            if let label = subview as? UILabel {
                label.removeFromSuperview()
            }
        }
    }

    // MARK: - Private methods

    private func createDrawingPoint(at point: CGPoint, with size: CGFloat) -> DrawingPoint {
        return DrawingPoint(x: point.x, y: point.y, size: size, emoji: getEmojiPaletteViewController()?.emojiPalette.getEmoji() ?? ":(")
    }

    private func convertDrawingPointToLabel(drawingPoint: DrawingPoint) -> UILabel {
        let emoji = UILabel(frame: CGRect.zero)
        emoji.text = drawingPoint.emoji
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

    private func getEmojiPaletteContainer() -> UINavigationController? {
        if emojiPaletteContainer != nil {
            return emojiPaletteContainer
        }

        let navigationControllerStoryboard = UIStoryboard(
            name: EmojiPaletteTableViewController.storyboard,
            bundle: Bundle(for: EmojiPaletteTableViewController.self))
        emojiPaletteContainer = navigationControllerStoryboard.instantiateInitialViewController() as? UINavigationController
        emojiPaletteContainer?.modalPresentationStyle = .popover
        return emojiPaletteContainer
    }

    private func getEmojiPaletteViewController() -> EmojiPaletteTableViewController? {
        if emojiPaletteViewController != nil {
            return emojiPaletteViewController
        }

        emojiPaletteViewController = getEmojiPaletteContainer()?.topViewController as? EmojiPaletteTableViewController
        return emojiPaletteViewController
    }

}
