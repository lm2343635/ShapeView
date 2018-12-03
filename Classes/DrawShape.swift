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

public struct ShapePath {
    
    let drawShape: DrawShape
    
    public static func custom(_ drawShape: @escaping DrawShape) -> ShapePath {
        return .init(drawShape: drawShape)
    }
    
    public static func corner(radius: CGFloat, bounds: @escaping () -> CGRect) -> ShapePath {
        let drawShape: DrawShape = {
            let bounds = bounds()
            $0.move(to: CGPoint(x: radius, y: 0))
            $0.addArc(withCenter: CGPoint(x: bounds.width - radius, y: radius), radius: radius, startAngle: -.pi / 2, endAngle: 0, clockwise: true)
            $0.addArc(withCenter: CGPoint(x: bounds.width - radius, y: bounds.height - radius), radius: radius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
            $0.addArc(withCenter: CGPoint(x: radius, y: bounds.height - radius), radius: radius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
            $0.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: -.pi, endAngle: -.pi / 2, clockwise: true)
        }
        return .init(drawShape: drawShape)
    }
    
    public static func dialog(radius: CGFloat, arrowPosition: DialogArrowPosition, bounds: @escaping () -> CGRect) -> ShapePath {
        let drawShape: DrawShape = {
            let bounds = bounds()
            
            switch arrowPosition {
            case .top(let center, let width, let height):
                $0.move(to: CGPoint(x: radius, y: height))
                $0.addLine(to: CGPoint(x: center + width / 2, y: height))
                $0.addLine(to: CGPoint(x: center, y: 0))
                $0.addLine(to: CGPoint(x: center - width / 2, y: height))
                $0.addArc(withCenter: CGPoint(x: bounds.width - radius, y: radius + height), radius: radius, startAngle: -.pi / 2, endAngle: 0, clockwise: true)
                $0.addArc(withCenter: CGPoint(x: bounds.width - radius, y: bounds.height - radius), radius: radius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
                $0.addArc(withCenter: CGPoint(x: radius, y: bounds.height - radius), radius: radius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
                $0.addArc(withCenter: CGPoint(x: radius, y: radius + height), radius: radius, startAngle: -.pi, endAngle: -.pi / 2, clockwise: true)
            case .bottom(let center, let width, let height):
                $0.move(to: CGPoint(x: radius, y: 0))
                $0.addArc(withCenter: CGPoint(x: bounds.width - radius, y: radius), radius: radius, startAngle: -.pi / 2, endAngle: 0, clockwise: true)
                $0.addArc(withCenter: CGPoint(x: bounds.width - radius, y: bounds.height - height - radius), radius: radius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
                $0.addLine(to: CGPoint(x: center + width / 2, y: bounds.height - height))
                $0.addLine(to: CGPoint(x: center, y: bounds.height))
                $0.addLine(to: CGPoint(x: center - width / 2, y: bounds.height - height))
                $0.addArc(withCenter: CGPoint(x: radius, y: bounds.height - height - radius), radius: radius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
                $0.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: -.pi, endAngle: -.pi / 2, clockwise: true)
            case .left(let center, let width, let height):
                $0.move(to: CGPoint(x: radius + width, y: 0))
                $0.addArc(withCenter: CGPoint(x: bounds.width - radius, y: radius), radius: radius, startAngle: -.pi / 2, endAngle: 0, clockwise: true)
                $0.addArc(withCenter: CGPoint(x: bounds.width - radius, y: bounds.height - radius), radius: radius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
                $0.addArc(withCenter: CGPoint(x: radius + width, y: bounds.height - radius), radius: radius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
                $0.addArc(withCenter: CGPoint(x: radius + width, y: radius), radius: radius, startAngle: -.pi, endAngle: -.pi / 2, clockwise: true)
                $0.addLine(to: CGPoint(x: width, y: center + height / 2))
                $0.addLine(to: CGPoint(x: 0, y: center))
                $0.addLine(to: CGPoint(x: width, y: center - height / 2))
                break
            case .right(let center, let width, let height):
                $0.move(to: CGPoint(x: radius, y: 0))
                $0.addArc(withCenter: CGPoint(x: bounds.width - radius - width, y: radius), radius: radius, startAngle: -.pi / 2, endAngle: 0, clockwise: true)
                $0.addLine(to: CGPoint(x: bounds.width - width, y: center + height / 2))
                $0.addLine(to: CGPoint(x: bounds.width, y: center))
                $0.addLine(to: CGPoint(x: bounds.width - width, y: center - height / 2))
                $0.addArc(withCenter: CGPoint(x: bounds.width - radius - width, y: bounds.height - radius), radius: radius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
                $0.addArc(withCenter: CGPoint(x: radius, y: bounds.height - radius), radius: radius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
                $0.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: -.pi, endAngle: -.pi / 2, clockwise: true)
                break
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
