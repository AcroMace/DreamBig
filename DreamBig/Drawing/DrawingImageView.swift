//
//  DrawingImageView.swift
//  DreamBig
//
//  Created by Andy Cho on 2017-06-16.
//  Copyright © 2017 AcroMace. All rights reserved.
//

import UIKit

protocol DrawingImageViewDelegate: class {
    func drewEmoji(at point: CGPoint, with size: CGFloat)
}

class DrawingImageView: UIImageView {
    weak var delegate: DrawingImageViewDelegate?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        respondToTouches(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        respondToTouches(touches)
    }

    private func respondToTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let size = touch.force > 0 ? touch.force : 1
        delegate?.drewEmoji(at: location, with: size)
    }
}
