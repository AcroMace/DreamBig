//
//  EmojiPaletteTableViewController.swift
//  DreamBig
//
//  Created by Andy Cho on 2017-07-01.
//  Copyright © 2017 AcroMace. All rights reserved.
//

import UIKit

class EmojiPaletteTableViewController: UITableViewController {

    static let storyboard = "EmojiPaletteTableViewController"

    let emojiPalette = EmojiPalette()

    @IBAction func didPressAddEmojiButton(_ sender: Any) {
        let alert = UIAlertController(title: "Add emoji", message: nil, preferredStyle: .alert)
        let okay = UIAlertAction(title: "OK", style: .default) { _ in
            guard let alertTextField = alert.textFields?.first else { return }
            guard let emoji = alertTextField.text else { return }
            self.emojiPalette.addEmojiToPalette(emoji: emoji)
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addTextField { textField in
            textField.placeholder = "Enter emoji here"
        }
        alert.addAction(okay)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

}

// MARK: - Table view data source

extension EmojiPaletteTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojiPalette.count()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DrawingEmojiTableViewCell.reuseIdentifier) as? DrawingEmojiTableViewCell else {
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        emojiPalette.selectEmoji(index: indexPath.row)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            emojiPalette.deleteEmoji(index: indexPath.row)
            tableView.reloadData()
        }
    }

}
