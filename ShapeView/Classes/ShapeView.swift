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

open class ShapeView: UIView {

    private lazy var shapeLayer: ShapeLayer = {
        let layer = ShapeLayer()
        layer.didUpdateLayer = { [unowned self] in
            guard self.bounds != .zero else {
                return
            }
            self.containerView.layer.mask = $0
        }
        return layer
    }()
    
    private lazy var effectView = UIVisualEffectView()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.addSubview(effectView)
        return view
    }()
    
    public var path: ShapePath? {
        didSet {
            shapeLayer.layerPath = path
        }
    }

    public var outerShadow: ShapeShadow? {
        didSet {
            shapeLayer.outerShadow = outerShadow
        }
    }
    
    public var innerShadow: ShapeShadow? {
        didSet {
            shapeLayer.innerShadow = innerShadow
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
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

        layer.addSublayer(shapeLayer)
        super.addSubview(containerView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override var backgroundColor: UIColor? {
        didSet {
            shapeLayer.backgroundColor = backgroundColor?.cgColor
            super.backgroundColor = .clear
        }
    }
    
    open override var bounds: CGRect {
        didSet {
            shapeLayer.frame = bounds
            effectView.frame = bounds
            containerView.frame = bounds
        }
    }
    
    private func blur() {
        guard let style = blurEffectStyle else {
            return
        }
        effectView.effect = UIBlurEffect(style: style)
        effectView.alpha = blurAlpha
    }

}

extension ShapeView {
    
    open override func addSubview(_ view: UIView) {
        containerView.addSubview(view)
    }
    
    open override func insertSubview(_ view: UIView, at index: Int) {
        containerView.insertSubview(view, at: index - 1)
    }
    
    open override func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) {
        containerView.insertSubview(view, aboveSubview: siblingSubview)
    }
    
    open override func exchangeSubview(at index1: Int, withSubviewAt index2: Int) {
        containerView.exchangeSubview(at: index1 - 1, withSubviewAt: index2 - 1)
    }
    
}
