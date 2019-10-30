//
//  ShapePath+Corner.swift
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
    
    public static func corner(radius: CGFloat, bounds: @escaping GetBounds) -> ShapePath {
        let drawShape: DrawShape = {
            let bounds = bounds()
            $0.move(to: CGPoint(x: radius, y: 0))
            $0.addArc(
                withCenter: CGPoint(x: bounds.width - radius, y: radius),
                radius: radius,
                startAngle: -.pi / 2,
                endAngle: 0,
                clockwise: true
            )
            $0.addArc(
                withCenter: CGPoint(x: bounds.width - radius, y: bounds.height - radius),
                radius: radius,
                startAngle: 0,
                endAngle: .pi / 2,
                clockwise: true
            )
            $0.addArc(
                withCenter: CGPoint(x: radius, y: bounds.height - radius),
                radius: radius,
                startAngle: .pi / 2,
                endAngle: .pi,
                clockwise: true
            )
            $0.addArc(
                withCenter: CGPoint(x: radius, y: radius),
                radius: radius,
                startAngle: -.pi,
                endAngle: -.pi / 2,
                clockwise: true
            )
        }
        return .init(drawShape)
    }
    
    public static func hollowCorner(radius: CGFloat, outlineWidth: CGFloat, bounds: @escaping GetBounds) -> ShapePath {
        let drawShape: DrawShape = { path in
            let bounds = bounds()
            path.append({ () -> UIBezierPath in
                let path = UIBezierPath()
                path.move(to: CGPoint(x: radius, y: outlineWidth))
                path.addArc(withCenter: CGPoint(x: bounds.width - radius, y: radius), radius: radius - outlineWidth, startAngle: -.pi / 2, endAngle: 0, clockwise: true)
                path.addArc(withCenter: CGPoint(x: bounds.width - radius, y: bounds.height - radius), radius: radius - outlineWidth, startAngle: 0, endAngle: .pi / 2, clockwise: true)
                path.addArc(withCenter: CGPoint(x: radius, y: bounds.height - radius), radius: radius - outlineWidth, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
                path.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius - outlineWidth, startAngle: .pi, endAngle: -.pi / 2, clockwise: true)
                return path
            }())
            
            path.append({ () -> UIBezierPath in
                let path = UIBezierPath()
                path.move(to: CGPoint(x: radius, y: 0))
                path.addArc(withCenter: CGPoint(x: bounds.width - radius, y: radius), radius: radius, startAngle: -.pi / 2, endAngle: 0, clockwise: true)
                path.addArc(withCenter: CGPoint(x: bounds.width - radius, y: bounds.height - radius), radius: radius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
                path.addArc(withCenter: CGPoint(x: radius, y: bounds.height - radius), radius: radius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
                path.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: .pi, endAngle: -.pi / 2, clockwise: true)
                return path
            }().reversing())
        }
        return .init(drawShape)
    }
    
}
