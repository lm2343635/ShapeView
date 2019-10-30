//
//  ShapePath+Star.swift
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
    
    public static func star(vertex: Int, extrusion: CGFloat = 10, bounds: @escaping GetBounds) -> ShapePath {
        let pointFrom = { (angle: CGFloat,
            radius:  CGFloat, offset: CGPoint) -> CGPoint in
            return CGPoint(x: radius * cos(angle) + offset.x, y: radius * sin(angle) + offset.y)
        }
        let drawShape: DrawShape = { path in
            let bounds = bounds()
            let center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
            var angle: CGFloat = -.pi / 2.0
            let angleIncrement = .pi * 2.0 / CGFloat(vertex)
            let radius = bounds.width / 2.0
            
            var firstPoint = true
            (1...vertex).forEach { _ in
                let point = pointFrom(angle, radius, center)
                let nextPoint = pointFrom(angle + angleIncrement, radius, center)
                let midPoint = pointFrom(angle + angleIncrement / 2.0, extrusion, center)
                
                if firstPoint {
                    firstPoint = false
                    path.move(to: point)
                }
                
                path.addLine(to: midPoint)
                path.addLine(to: nextPoint)
                
                angle += angleIncrement
            }
        }
        return .init(drawShape)
    }
    
}
