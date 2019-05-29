//
//  DrawShape.swift
//  ShapeView
//
//  Created by Meng Li  on 2018/12/03.
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

public typealias DrawShape = ((UIBezierPath) -> Void)
public typealias GetBounds = (() -> CGRect)

public struct ShapePath {
    
    let drawShape: DrawShape
    
    public static func custom(_ drawShape: @escaping DrawShape) -> ShapePath {
        return .init(drawShape: drawShape)
    }
    
    public static func corner(radius: CGFloat, bounds: @escaping () -> CGRect) -> ShapePath {
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
        return .init(drawShape: drawShape)
    }
    
    public static func dialog(radius: CGFloat, arrowPosition: DialogArrowPosition, bounds: @escaping GetBounds) -> ShapePath {
        let drawShape: DrawShape = {
            let bounds = bounds()
            
            switch arrowPosition {
            case .top(let center, let width, let height):
                $0.move(to: CGPoint(x: radius, y: height))
                $0.addLine(to: CGPoint(x: center + width / 2, y: height))
                $0.addLine(to: CGPoint(x: center, y: 0))
                $0.addLine(to: CGPoint(x: center - width / 2, y: height))
                $0.addArc(
                    withCenter: CGPoint(x: bounds.width - radius, y: radius + height), 
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
                    withCenter: CGPoint(x: radius, y: radius + height),
                    radius: radius,
                    startAngle: -.pi,
                    endAngle: -.pi / 2,
                    clockwise: true
                )
            case .bottom(let center, let width, let height):
                $0.move(to: CGPoint(x: radius, y: 0))
                $0.addArc(
                    withCenter: CGPoint(x: bounds.width - radius, y: radius),
                    radius: radius,
                    startAngle: -.pi / 2,
                    endAngle: 0,
                    clockwise: true
                )
                $0.addArc(
                    withCenter: CGPoint(x: bounds.width - radius, y: bounds.height - height - radius),
                    radius: radius,
                    startAngle: 0,
                    endAngle: .pi / 2,
                    clockwise: true
                )
                $0.addLine(to: CGPoint(x: center + width / 2, y: bounds.height - height))
                $0.addLine(to: CGPoint(x: center, y: bounds.height))
                $0.addLine(to: CGPoint(x: center - width / 2, y: bounds.height - height))
                $0.addArc(
                    withCenter: CGPoint(x: radius, y: bounds.height - height - radius),
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
            case .left(let center, let width, let height):
                $0.move(to: CGPoint(x: radius + width, y: 0))
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
                    withCenter: CGPoint(x: radius + width, y: bounds.height - radius),
                    radius: radius,
                    startAngle: .pi / 2,
                    endAngle: .pi,
                    clockwise: true
                )
                $0.addArc(
                    withCenter: CGPoint(x: radius + width, y: radius),
                    radius: radius,
                    startAngle: -.pi,
                    endAngle: -.pi / 2,
                    clockwise: true
                )
                $0.addLine(to: CGPoint(x: width, y: center + height / 2))
                $0.addLine(to: CGPoint(x: 0, y: center))
                $0.addLine(to: CGPoint(x: width, y: center - height / 2))
            case .right(let center, let width, let height):
                $0.move(to: CGPoint(x: radius, y: 0))
                $0.addArc(
                    withCenter: CGPoint(x: bounds.width - radius - width, y: radius),
                    radius: radius,
                    startAngle: -.pi / 2,
                    endAngle: 0,
                    clockwise: true
                )
                $0.addLine(to: CGPoint(x: bounds.width - width, y: center + height / 2))
                $0.addLine(to: CGPoint(x: bounds.width, y: center))
                $0.addLine(to: CGPoint(x: bounds.width - width, y: center - height / 2))
                $0.addArc(
                    withCenter: CGPoint(x: bounds.width - radius - width, y: bounds.height - radius),
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
        }
        return .init(drawShape: drawShape)
    }
    
    public static func cuteDialog(radius: CGFloat, arrowPosition: CuteDialogArrowPosition, bounds: @escaping GetBounds) -> ShapePath {
        let drawShape: DrawShape = {
            let bounds = bounds()
            switch arrowPosition {
            case .leftBottom(let width, let height):
                $0.move(to: CGPoint(x: radius, y: 0))
                $0.addArc(
                    withCenter: CGPoint(x: bounds.width - radius, y: radius),
                    radius: radius,
                    startAngle: -.pi / 2,
                    endAngle: 0,
                    clockwise: true
                )
                $0.addArc(
                    withCenter: CGPoint(x: bounds.width - radius, y: bounds.height - radius - height),
                    radius: radius,
                    startAngle: 0,
                    endAngle: .pi / 2,
                    clockwise: true
                )
                $0.addLine(to: CGPoint(x: width, y: bounds.height - height))
                $0.addCurve(
                    to: CGPoint(x: 0, y: bounds.height),
                    controlPoint1: CGPoint(x: width / 2, y: bounds.height - height),
                    controlPoint2: CGPoint(x: 0, y: bounds.height - height / 2)
                )
                $0.addArc(
                    withCenter: CGPoint(x: radius, y: radius),
                    radius: radius,
                    startAngle: -.pi,
                    endAngle: -.pi / 2,
                    clockwise: true
                )
            case .rightBottom(let width, let height):
                $0.move(to: CGPoint(x: radius, y: 0))
                $0.addArc(
                    withCenter: CGPoint(x: bounds.width - radius, y: radius),
                    radius: radius,
                    startAngle: -.pi / 2,
                    endAngle: 0,
                    clockwise: true
                )
                $0.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
                $0.addCurve(
                    to: CGPoint(x: bounds.width - width, y: bounds.height - height),
                    controlPoint1: CGPoint(x: bounds.width, y: bounds.height - height / 2),
                    controlPoint2: CGPoint(x: bounds.width - width / 2, y: bounds.height - height)
                )
                $0.addArc(
                    withCenter: CGPoint(x: radius, y: bounds.height - height - radius),
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
        }
        return .init(drawShape: drawShape)
    }
    
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
        return .init(drawShape: drawShape)
    }
    
}

public enum DialogArrowPosition {
    case top(center: CGFloat, width: CGFloat, height: CGFloat)
    case bottom(center: CGFloat, width: CGFloat, height: CGFloat)
    case right(center: CGFloat, width: CGFloat, height: CGFloat)
    case left(center: CGFloat, width: CGFloat, height: CGFloat)
}

public enum CuteDialogArrowPosition {
    case leftBottom(width: CGFloat, height: CGFloat)
    case rightBottom(width: CGFloat, height: CGFloat)
}
