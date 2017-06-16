//
//  DrawingModel.swift
//  DreamBig
//
//  Created by Andy Cho on 2017-06-16.
//  Copyright © 2017 AcroMace. All rights reserved.
//

import UIKit

// Represents one emoji point
struct DrawingPoint {
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let emoji: String
}

// The model used to describe everything needed to draw the emojis
class DrawingModel {
    private(set) var points: [DrawingPoint]
    let canvasSize: CGSize

    init(canvasSize: CGSize) {
        self.canvasSize = canvasSize
        points = []
    }

    func addPoint(point: DrawingPoint) {
        points.append(point)
    }

    func clearPoints() {
        points = []
    }
}
