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
    
    var customizeShapeLayer: ((CAShapeLayer) -> Void)? {
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
    
    func refresh() {
        shapeLayer?.removeFromSuperlayer()
        
        let path = UIBezierPath()
        if drawShape == nil {
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: bounds.width, y: 0))
            path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
            path.addLine(to: CGPoint(x: 0, y: bounds.height))
        } else {
            drawShape?(path)
        }
        path.close()
        
        shapeLayer = CAShapeLayer()
        guard let shapeLayer = shapeLayer else {
            return
        }
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = shapeLayerFillColor
        customizeShapeLayer?(shapeLayer)
        layer.insertSublayer(shapeLayer, at: 0)
    }
    
}

