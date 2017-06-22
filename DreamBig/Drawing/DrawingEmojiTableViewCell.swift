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

    @IBOutlet weak var emojiLabel: UILabel!

    func config(emoji: String) {
        emojiLabel.text = emoji
    }

}
