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
    
    var shapeShadow: ShapeShadow? {
        get {
            guard let shadowColor = shadowColor, shadowColor == fillColor else {
                return nil
            }
            return ShapeShadow(radius: shadowRadius, color: UIColor(cgColor: shadowColor), opacity: shadowOpacity, offset: shadowOffset)
        }
        set {
            shadowRadius = newValue?.radius ?? 0
            shadowColor = newValue?.color.cgColor
            shadowOpacity = newValue?.opacity ?? 0
            shadowOffset = newValue?.offset ?? .zero
            fillColor = newValue?.color.cgColor
        }
    }
    
}

public class ShapeLayer: CAShapeLayer {
    
    private let outerShadowLayer = CAShapeLayer()
    private let backgroundLayer = CALayer()
    private let innerShadowLayer = CAShapeLayer()
    private let effectLayer = CAShapeLayer()
    private let effectView = UIVisualEffectView()
    
    // The shadow path is drawed by the closure drawShape.
    // When the drawShape cloure is updated, the shapePath should be updated.
    private var shapePath = UIBezierPath(rect: .zero)
    
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
    
    public var effect: UIVisualEffect? {
        get {
            return effectView.effect
        }
        set {
            effectView.effect = newValue
        }
    }
    
    public var effectAlpha: CGFloat {
        get {
            return effectView.alpha
        }
        set {
            effectView.alpha = newValue
        }
    }
    
    public var didUpdateLayer: ((CAShapeLayer) -> Void)?
    
    open override var backgroundColor: CGColor? {
        didSet {
            backgroundLayer.backgroundColor = backgroundColor
            super.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    override public init() {
        super.init()
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    public override init(layer: Any) {
        super.init(layer: layer)
        initialize()
    }
    
    private func initialize() {
        addSublayer(outerShadowLayer)
        addSublayer(backgroundLayer)
        addSublayer(effectLayer)
        addSublayer(innerShadowLayer)
        
        backgroundLayer.masksToBounds = true
        
        innerShadowLayer.masksToBounds = true
        innerShadowLayer.fillRule = .evenOdd
        
        effectLayer.addSublayer(effectView.layer)
        effectLayer.masksToBounds = true
        
        effectView.alpha = 0
    }
    
    open override var bounds: CGRect {
        didSet {
            guard bounds != .zero else {
                return
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
        guard let innerShadow = innerShadow else {
            innerShadowLayer.isHidden = true
            return
        }
        innerShadowLayer.isHidden = false
        innerShadowLayer.frame = bounds
        innerShadowLayer.shapeShadow = innerShadow
        innerShadowLayer.path = {
            let path = UIBezierPath()
            path.append(screenPath)
            path.append(shapePath)
            return path.cgPath
            }()
        innerShadowLayer.mask = {
            let cutLayer = CAShapeLayer()
            cutLayer.path = shapePath.cgPath
            return cutLayer
        }()
    }
    
    private func refreshOuter() {
        guard let outerShadow = outerShadow else {
            outerShadowLayer.isHidden = true
            return
        }
        outerShadowLayer.isHidden = false
        outerShadowLayer.path = shapePath.cgPath
        outerShadowLayer.shapeShadow = outerShadow
        outerShadowLayer.mask = {
            let cutLayer = CAShapeLayer()
            cutLayer.path = {
                let path = UIBezierPath()
                path.append(shapePath)
                path.append(screenPath)
                path.usesEvenOddFillRule = true
                return path.cgPath
            }()
            cutLayer.fillRule = .evenOdd
            return cutLayer
        }()
    }
    
    private func refreshBackground() {
        backgroundLayer.frame = bounds
        backgroundLayer.mask = {
            let cutLayer = CAShapeLayer()
            cutLayer.path = shapePath.cgPath
            return cutLayer
        }()
    }
    
    private func refreshEffect() {
        effectLayer.frame = bounds
        effectLayer.mask = {
            let cutLayer = CAShapeLayer()
            cutLayer.path = shapePath.cgPath
            return cutLayer
        }()
        
        effectView.frame = bounds
    }
    
    private func refresh() {
        refreshOuter()
        refreshInner()
        refreshBackground()
        refreshEffect()
        
        let cutLayer = CAShapeLayer()
        cutLayer.path = shapePath.cgPath
        didUpdateLayer?(cutLayer)
    }
    
}
