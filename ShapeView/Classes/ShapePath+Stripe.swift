//
//  ShapePath+Stripe.swift
//  ShapeView
//
//  Created by Meng Li on 2019/09/04.
//  Copyright © 2018 MuShare. All rights reserved.
//

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

extension ShapePath {
    
    public static func stripe(
        width: CGFloat = 5,
        angle: Double = .pi / 4,
        bounds: @escaping GetBounds
    ) -> ShapePath {
        let drawShape: DrawShape
        switch angle {
        case 0, .pi:
            drawShape = { path in
                let bounds = bounds()
                var currentHeight: CGFloat = 0
                while currentHeight < bounds.height {
                    path.move(to: CGPoint(x: 0, y: currentHeight))
                    path.addLine(to: CGPoint(x: bounds.width, y: currentHeight))
                    path.addLine(to: CGPoint(x: bounds.width, y: currentHeight + width))
                    path.addLine(to: CGPoint(x: 0, y: currentHeight + width))
                    currentHeight += width * 2
                }
            }
        case 0 ..< .pi / 2:
            let unitWidth = width / CGFloat(sin(angle))
            let unitHeight = width / CGFloat(cos(angle))
            drawShape = { path in
                let bounds = bounds()
                let canvasMaxWidth = bounds.width + bounds.width / CGFloat(tan(angle))
                var currentWidth: CGFloat = 0
                var currentHeight: CGFloat = 0
                while currentWidth < canvasMaxWidth {
                    path.move(to: CGPoint(x: currentWidth, y: 0))
                    path.addLine(to: CGPoint(x: currentWidth + unitWidth, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: currentHeight + unitHeight))
                    path.addLine(to: CGPoint(x: 0, y: currentHeight))
                    currentWidth += unitWidth * 2
                    currentHeight += unitHeight * 2
                }
            }
        case .pi / 2:
            drawShape = { path in
                let bounds = bounds()
                var currentWidth: CGFloat = 0
                while currentWidth < bounds.width {
                    path.move(to: CGPoint(x: currentWidth, y: 0))
                    path.addLine(to: CGPoint(x: currentWidth + width, y: 0))
                    path.addLine(to: CGPoint(x: currentWidth + width, y: bounds.height))
                    path.addLine(to: CGPoint(x: currentWidth, y: bounds.height))
                    currentWidth += width * 2
                }
            }
        case .pi / 2 ..< .pi:
            let unitWidth = width / CGFloat(sin(angle))
            let unitHeight = width / CGFloat(cos(angle))
            drawShape = { path in
                let bounds = bounds()
                let canvasMaxWidth = bounds.width - bounds.width / CGFloat(tan(angle))
                var currentWidth: CGFloat = 0
                var currentHeight: CGFloat = bounds.height
                while currentWidth < canvasMaxWidth {
                    path.move(to: CGPoint(x: currentWidth, y: bounds.height))
                    path.addLine(to: CGPoint(x: currentWidth + unitWidth, y: bounds.height))
                    path.addLine(to: CGPoint(x: 0, y: currentHeight + unitHeight))
                    path.addLine(to: CGPoint(x: 0, y: currentHeight))
                    currentWidth += unitWidth * 2
                    currentHeight += unitHeight * 2
                }
            }
        default:
            fatalError("Angle must be in [0, pi]")
        }
        return .init(drawShape: drawShape)
    }
    
}
