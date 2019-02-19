//
//  ShapeView.swift
//  ShapeView
//
//  Created by Meng Li on 2018/11/28.
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
    var raduis: CGFloat
    var color: UIColor
    var opacity: Float
    var offset: CGSize
    
    public init(raduis: CGFloat = 0, color: UIColor = .clear, opacity: Float = 1, offset: CGSize = .zero) {
        self.raduis = raduis
        self.color = color
        self.opacity = opacity
        self.offset = offset
    }
}

extension CAShapeLayer {
    
    func setShapeShadow(_ shadow: ShapeShadow) {
        shadowRadius = shadow.raduis
        shadowColor = shadow.color.cgColor
        shadowOpacity = shadow.opacity
        shadowOffset = shadow.offset
        fillColor = shadow.color.cgColor
    }
    
}

open class ShapeView: UIView {
    
    private lazy var outerShadowLayer = CAShapeLayer()
    private lazy var backgroundLayer = CALayer()
    private lazy var innerShadowLayer = CAShapeLayer()
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.layer.addSublayer(outerShadowLayer)
        view.layer.addSublayer(backgroundLayer)
        view.layer.addSublayer(innerShadowLayer)
        return view
    }()
    
    private lazy var effectView = UIVisualEffectView()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.addSubview(effectView)
        return view
    }()
    
    public var path: ShapePath? {
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
    
    public var blurEffectStyle: UIBlurEffect.Style? {
        didSet {
            blur()
        }
    }
    
    public var blurAlpha: CGFloat = 0 {
        didSet {
            blur()
        }
    }
    
    // The shadow path is drawed by the closure drawShape.
    // When the drawShape cloure is updated, the shapePath should be updated.
    private var shapePath: UIBezierPath?
    
    // The screen path is used for creating the mask to cut the shadow layer.
    // When the bounds is updated, it should be updated.
    private var screenPath: UIBezierPath?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = false
        
        addSubview(shadowView)
        addSubview(containerView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override var backgroundColor: UIColor? {
        didSet {
//            containerView.backgroundColor = backgroundColor
            backgroundLayer.backgroundColor = backgroundColor?.cgColor
            super.backgroundColor = .clear
        }
    }
    
    // Add subviews should be added to the container view except shadowLayerView and containerView.
    open override func addSubview(_ view: UIView) {
        if [shadowView, containerView].contains(view) {
            super.addSubview(view)
        } else {
            containerView.addSubview(view)
        }
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)

        shadowView.frame = bounds
        containerView.frame = bounds
        effectView.frame = bounds
        
        updateShapePath()
        updateScreenPath()
        refresh()
        blur()
    }

    private func updateShapePath() {
        let drawShape = path?.drawShape
        shapePath = (drawShape == nil) ? UIBezierPath(rect: bounds) : {
            let path = UIBezierPath()
            drawShape?(path)
            path.close()
            return path
        }()
    }
    
    private func updateScreenPath() {
        screenPath = {
            let path = UIBezierPath()
            let main = UIScreen.main.bounds
            path.move(to: CGPoint(x: -frame.origin.x, y: -frame.origin.y))
            path.addLine(to: CGPoint(x: main.width - frame.origin.x, y: -frame.origin.y))
            path.addLine(to: CGPoint(x: main.width - frame.origin.x, y: main.height - frame.origin.y))
            path.addLine(to: CGPoint(x: -frame.origin.x, y: main.height - frame.origin.y))
            path.close()
            return path
        }()
    }
    
    private func refreshInner() {
        guard
            let shapePath = shapePath,
            let screenPath = screenPath,
            let shadow = innerShadow
        else {
            return
        }
        
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
        guard
            let shapePath = shapePath,
            let screenPath = screenPath,
            let shadow = outerShadow
        else {
            return
        }

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
        guard let shapePath = shapePath else {
            return
        }
        refreshOuter()
        refreshInner()
        refreshBackground()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = shapePath.cgPath
        containerView.layer.mask = shapeLayer
    }

    private func blur() {
        guard let style = blurEffectStyle else {
            return
        }
        effectView.effect = UIBlurEffect(style: style)
        effectView.alpha = blurAlpha
    }
    
}
