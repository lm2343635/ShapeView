//
//  ShapeView.swift
//  ShapeView
//
//  Created by Meng Li on 2018/11/28.
//  Copyright © 2018 MuShare. All rights reserved.
//

import UIKit

public class ShapeView: UIView {
    
    private lazy var shadowLayerView = UIView()
    private lazy var containerView = UIView()
    
    public var drawShape: ((UIBezierPath) -> Void)? {
        didSet {
            updateShapePath()
            refresh()
        }
    }

    @IBInspectable public var shadowRaduis: CGFloat = 0 {
        didSet {
            refresh()
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = .clear {
        didSet {
            refresh()
        }
    }
    
    @IBInspectable public var shadowOpacity: Float = 1 {
        didSet {
            refresh()
        }
    }
    
    @IBInspectable public var shaowOffset: CGSize = .zero {
        didSet {
            refresh()
        }
    }
    
    // The shadow path is drawed by the closure drawShape.
    // When the drawShape cloure is updated, the shapePath should be updated.
    private var shapePath: UIBezierPath?
    
    // The screen path is used for creating the mask to cut the shadow layer.
    // When the bounds is updated, it should be updated.
    private var screenPath: UIBezierPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = false
        addSubview(shadowLayerView)
        addSubview(containerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var backgroundColor: UIColor? {
        didSet {
            containerView.backgroundColor = backgroundColor
            super.backgroundColor = .clear
        }
    }
    
    // Add subviews should be added to the container view except shadowLayerView and containerView.
    public override func addSubview(_ view: UIView) {
        if [shadowLayerView, containerView].contains(view) {
            super.addSubview(view)
        } else {
            containerView.addSubview(view)
        }
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        shadowLayerView.frame = bounds
        containerView.frame = bounds
        updateShapePath()
        updateScreenPath()
        refresh()
    }

    private func updateShapePath() {
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
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = shapePath.cgPath
        if shadowRaduis > 0 && shadowColor != .clear {
            shadowLayer.shadowRadius = shadowRaduis
            shadowLayer.shadowColor = shadowColor.cgColor
            shadowLayer.shadowOpacity = shadowOpacity
            shadowLayer.shadowOffset = shaowOffset
            shadowLayer.fillColor = shadowColor.cgColor
        }
        shadowLayerView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        shadowLayerView.layer.insertSublayer(shadowLayer, at: 0)
        
        let cutLayer = CAShapeLayer()
        cutLayer.path = { () -> UIBezierPath in
            let path = UIBezierPath()
            path.append(shapePath)
            path.append(screenPath)
            path.usesEvenOddFillRule = true
            return path
        }().cgPath
        cutLayer.fillRule = .evenOdd
        shadowLayerView.layer.mask = cutLayer
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = shapePath.cgPath
        containerView.layer.mask = shapeLayer
    }

}
