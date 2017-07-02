//
//  DrawingEmojiTableViewCell.swift
//  DreamBig
//
//  Created by Andy Cho on 2017-06-22.
//  Copyright © 2017 AcroMace. All rights reserved.
//

import UIKit

class DrawingEmojiTableViewCell: UITableViewCell {

    static let reuseIdentifier = "DrawingEmojiTableViewCell"
    private static let selectedColor = UIColor.init(hue: 0, saturation: 0, brightness: 0, alpha: 0.05)
    private static let deselectedColor = UIColor.white

    @IBOutlet weak var emojiLabel: UILabel!

    func config(emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        backgroundColor = isSelected ? DrawingEmojiTableViewCell.selectedColor : DrawingEmojiTableViewCell.deselectedColor
    }

}
