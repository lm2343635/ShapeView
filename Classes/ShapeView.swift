//
//  ShapeView.swift
//  ShapeView
//
//  Created by Meng Li on 2018/11/28.
//  Copyright © 2018 MuShare. All rights reserved.
//

import UIKit

public class ShapeView: UIView {
    
    var drawShape: ((UIBezierPath) -> Void)? {
        didSet {
            if shapeLayer != nil {
                refresh()
            }
        }
    }
    
    private var shapeLayer: CAShapeLayer?
    private var shapeLayerFillColor: CGColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var backgroundColor: UIColor? {
        didSet {
            shapeLayerFillColor = backgroundColor?.cgColor
            super.backgroundColor = .clear
            if shapeLayer != nil {
                refresh()
            }
        }
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        refresh()
    }
    
    private func refresh() {
        shapeLayer?.removeFromSuperlayer()
        
        let shapePath = UIBezierPath()
        drawShape?(shapePath)
        shapePath.close()
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = shapePath.cgPath
        shadowLayer.fillRule = .evenOdd
        if shadowRaduis > 0 && shadowColor != .clear {
            shadowLayer.shadowRadius = shadowRaduis
            shadowLayer.shadowColor = shadowColor.cgColor
            shadowLayer.shadowOpacity = shadowOpacity
            shadowLayer.shadowOffset = shaowOffset
            shadowLayer.fillColor = shadowColor.cgColor
        }
        layer.insertSublayer(shadowLayer, at: 0)
        
        shapeLayer = CAShapeLayer()
        guard let shapeLayer = shapeLayer else {
            return
        }
        shapeLayer.path = { () -> UIBezierPath in
            let path = UIBezierPath()
            path.append(shapePath)
            path.append({
                let path = UIBezierPath()
                let main = UIScreen.main.bounds
                path.move(to: CGPoint(x: -frame.origin.x, y: -frame.origin.y))
                path.addLine(to: CGPoint(x: main.width - frame.origin.x, y: -frame.origin.y))
                path.addLine(to: CGPoint(x: main.width - frame.origin.x, y: main.height - frame.origin.y))
                path.addLine(to: CGPoint(x: -frame.origin.x, y: main.height - frame.origin.y))
                path.close()
                return path
            }())
            path.usesEvenOddFillRule = true
            return path
        }().cgPath
        shapeLayer.fillRule = .evenOdd
        layer.mask = shapeLayer
    }
    
    private var shadowRaduis: CGFloat = 0
    private var shadowColor: UIColor = .clear
    private var shadowOpacity: Float = 1
    private var shaowOffset: CGSize = .zero
    
    public func setShadow(raduis: CGFloat, color: UIColor, opacity: Float? = 1, offset: CGSize? = .zero) {
        shadowRaduis = raduis
        shadowColor = color
        if let opacity = opacity {
            shadowOpacity = opacity
        }
        if let offset = offset {
            shaowOffset = offset
        }
        if shapeLayer != nil {
            refresh()
        }
    }
    
}
