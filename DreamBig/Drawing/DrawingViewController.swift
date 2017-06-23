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
    let emojiPalette = EmojiPalette()
    var drawingModel: DrawingModel? // Model passed to the AR view controller after drawing

    @IBOutlet weak var drawingImageView: DrawingImageView!
    @IBOutlet weak var emojiTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        emojiTableView.delegate = self
        emojiTableView.dataSource = self
    }

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

    @IBAction func didPressAddEmojiButton(_ sender: Any) {
        let alert = UIAlertController(title: "Add emoji", message: nil, preferredStyle: .alert)
        let okay = UIAlertAction(title: "OK", style: .default) { _ in
            guard let alertTextField = alert.textFields?.first else { return }
            guard let emoji = alertTextField.text else { return }
            self.emojiPalette.addEmojiToPalette(emoji: emoji)
            self.emojiTableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addTextField { textField in
            textField.placeholder = "Enter emoji here"
        }
        alert.addAction(okay)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
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
        return DrawingPoint(x: point.x, y: point.y, size: size, emoji: emojiPalette.getEmoji())
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

}

extension DrawingViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojiPalette.count()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = emojiTableView.dequeueReusableCell(withIdentifier: DrawingEmojiTableViewCell.reuseIdentifier) as? DrawingEmojiTableViewCell else {
            print("ERROR: Failed to dequeue DrawingEmojiTableViewCell")
            return DrawingEmojiTableViewCell()
        }

        guard indexPath.row < emojiPalette.count() else {
            print("ERROR: Tried to dequeue out of range emoji")
            return DrawingEmojiTableViewCell()
        }

        cell.config(emoji: emojiPalette.getEmoji(index: indexPath.row), isSelected: emojiPalette.isSelectedEmoji(index: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        emojiPalette.selectEmoji(index: indexPath.row)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            emojiPalette.deleteEmoji(index: indexPath.row)
            tableView.reloadData()
        }
    }

}
