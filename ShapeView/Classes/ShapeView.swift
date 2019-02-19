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

open class ShapeView: UIView {
    
    private lazy var outerShadowLayerView = UIView()
    private lazy var innerShadowLayerView = UIView()
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
            refresh()
        }
    }
    
    public var innerShadow: ShapeShadow? {
        didSet {
            refresh()
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
        
        addSubview(outerShadowLayerView)
        addSubview(containerView)
        addSubview(innerShadowLayerView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override var backgroundColor: UIColor? {
        didSet {
            containerView.backgroundColor = backgroundColor
            super.backgroundColor = .clear
        }
    }
    
    // Add subviews should be added to the container view except shadowLayerView and containerView.
    open override func addSubview(_ view: UIView) {
        if [outerShadowLayerView, containerView, innerShadowLayerView].contains(view) {
            super.addSubview(view)
        } else {
            containerView.addSubview(view)
        }
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)

        outerShadowLayerView.frame = bounds
        innerShadowLayerView.frame = bounds
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
    
    private func refresh() {
        guard let shapePath = shapePath, let screenPath = screenPath else {
            return
        }

        if let shadow = innerShadow {
            let shadowLayer = CAShapeLayer()
            shadowLayer.frame = bounds
            shadowLayer.masksToBounds = true
            shadowLayer.fillRule = .evenOdd
            shadowLayer.path = { () -> UIBezierPath in
                let path = UIBezierPath()
                path.append(screenPath)
                path.append(shapePath)
                return path
            }().cgPath
            
            shadowLayer.shadowRadius = shadow.raduis
            shadowLayer.shadowColor = shadow.color.cgColor
            shadowLayer.shadowOpacity = shadow.opacity
            shadowLayer.shadowOffset = shadow.offset
            shadowLayer.fillColor = shadow.color.cgColor
            
            innerShadowLayerView.layer.addSublayer(shadowLayer)
            
            let cutLayer = CAShapeLayer()
            cutLayer.path = shapePath.cgPath
            innerShadowLayerView.layer.mask = cutLayer
        }
        
        if let shadow = outerShadow {
            
            let shadowLayer = CAShapeLayer()
            shadowLayer.path = shapePath.cgPath
            
            shadowLayer.shadowRadius = shadow.raduis
            shadowLayer.shadowColor = shadow.color.cgColor
            shadowLayer.shadowOpacity = shadow.opacity
            shadowLayer.shadowOffset = shadow.offset
            shadowLayer.fillColor = shadow.color.cgColor
            
            outerShadowLayerView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            outerShadowLayerView.layer.insertSublayer(shadowLayer, at: 0)
            
            let cutLayer = CAShapeLayer()
            cutLayer.path = { () -> UIBezierPath in
                let path = UIBezierPath()
                path.append(shapePath)
                path.append(screenPath)
                path.usesEvenOddFillRule = true
                return path
                }().cgPath
            cutLayer.fillRule = .evenOdd
            outerShadowLayerView.layer.mask = cutLayer
        }
        
        
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
