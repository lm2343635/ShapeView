//
//  ShapeLayer.swift
//  ShapeView
//
//  Created by Meng Li on 2019/02/19.
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

public struct ShapeShadow {
    
    var radius: CGFloat
    var color: UIColor
    var opacity: Float
    var offset: CGSize
    
    public init(radius: CGFloat = 0, color: UIColor = .clear, opacity: Float = 1, offset: CGSize = .zero) {
        self.radius = radius
        self.color = color
        self.opacity = opacity
        self.offset = offset
    }
    
}

fileprivate extension CAShapeLayer {
    
    func setShapeShadow(_ shadow: ShapeShadow) {
        shadowRadius = shadow.radius
        shadowColor = shadow.color.cgColor
        shadowOpacity = shadow.opacity
        shadowOffset = shadow.offset
        fillColor = shadow.color.cgColor
    }
    
}

public class ShapeLayer: CAShapeLayer {
    
    lazy var effectView = UIVisualEffectView()
    
    private let outerShadowLayer = CAShapeLayer()
    private let backgroundLayer = CALayer()
    private let effectLayer = CAShapeLayer()
    private let innerShadowLayer = CAShapeLayer()
    
    // The shadow path is drawed by the closure drawShape.
    // When the drawShape cloure is updated, the shapePath should be updated.
    private var shapePath: UIBezierPath?
    
    // The screen path is used for creating the mask to cut the shadow layer.
    // When the bounds is updated, it should be updated.
    private var screenPath: UIBezierPath = {
        let path = UIBezierPath()
        let main = UIScreen.main.bounds
        path.move(to: CGPoint(x: -main.width, y: -main.height))
        path.addLine(to: CGPoint(x: main.width, y: -main.height))
        path.addLine(to: CGPoint(x: main.width, y: main.height))
        path.addLine(to: CGPoint(x: -main.width, y: main.height))
        path.close()
        return path
    }()
    
    public var layerPath: ShapePath? {
        didSet {
            updateShapePath()
            refresh()
        }
    }
    
    public var outerShadow: ShapeShadow? {
        didSet {
            refreshOuter()
        }
    }
    
    public var innerShadow: ShapeShadow? {
        didSet {
            refreshInner()
        }
    }
    
    public var didUpdateLayer: ((CAShapeLayer) -> Void)?
    
    open override var backgroundColor: CGColor? {
        didSet {
            backgroundLayer.backgroundColor = backgroundColor
            super.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    private var initialized = false
    
    open override var bounds: CGRect {
        didSet {
            guard bounds != .zero else {
                return
            }
            if !initialized {
                addSublayer(outerShadowLayer)
                addSublayer(backgroundLayer)
                addSublayer(effectLayer)
                addSublayer(innerShadowLayer)
                effectLayer.addSublayer(effectView.layer)
                initialized = true
            }
            
            updateShapePath()
            refresh()
        }
    }
    
    private func updateShapePath() {
        let drawShape = layerPath?.drawShape
        shapePath = (drawShape == nil) ? UIBezierPath(rect: bounds) : {
            let path = UIBezierPath()
            drawShape?(path)
            path.close()
            return path
        }()
    }
    
    private func refreshInner() {
        guard let shapePath = shapePath, let shadow = innerShadow else {
            innerShadowLayer.isHidden = true
            return
        }
        innerShadowLayer.isHidden = false
        innerShadowLayer.frame = bounds
        innerShadowLayer.masksToBounds = true
        innerShadowLayer.fillRule = .evenOdd
        innerShadowLayer.path = { () -> UIBezierPath in
            let path = UIBezierPath()
            path.append(screenPath)
            path.append(shapePath)
            return path
        }().cgPath
        innerShadowLayer.setShapeShadow(shadow)
        
        let cutLayer = CAShapeLayer()
        cutLayer.path = shapePath.cgPath
        innerShadowLayer.mask = cutLayer
    }
    
    private func refreshOuter() {
        guard let shapePath = shapePath, let shadow = outerShadow else {
            outerShadowLayer.isHidden = true
            return
        }
        outerShadowLayer.isHidden = false
        outerShadowLayer.path = shapePath.cgPath
        outerShadowLayer.setShapeShadow(shadow)
        
        let cutLayer = CAShapeLayer()
        cutLayer.path = { () -> UIBezierPath in
            let path = UIBezierPath()
            path.append(shapePath)
            path.append(screenPath)
            path.usesEvenOddFillRule = true
            return path
        }().cgPath
        cutLayer.fillRule = .evenOdd
        outerShadowLayer.mask = cutLayer
    }
    
    private func refreshEffect() {
        guard let shapePath = shapePath else {
            return
        }
        effectLayer.frame = bounds
        effectView.frame = bounds
        let cutLayer = CAShapeLayer()
        cutLayer.path = shapePath.cgPath
        effectLayer.mask = cutLayer
    }
    
    private func refreshBackground() {
        guard let shapePath = shapePath else {
            return
        }
        backgroundLayer.frame = bounds
        let cutLayer = CAShapeLayer()
        cutLayer.path = shapePath.cgPath
        backgroundLayer.mask = cutLayer
    }
    
    private func refresh() {
        refreshOuter()
        refreshInner()
        refreshEffect()
        refreshBackground()
        
        if let shapePath = shapePath {
            let cutLayer = CAShapeLayer()
            cutLayer.path = shapePath.cgPath
            didUpdateLayer?(cutLayer)
        }
    }
    
}

class ShapeEffectView: UIVisualEffectView {
    
    override final class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override var layer: CAShapeLayer {
        return super.layer as! CAShapeLayer
    }
    
}
