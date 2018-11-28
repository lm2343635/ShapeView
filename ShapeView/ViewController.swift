//
//  ViewController.swift
//  ShapeView
//
//  Created by Meng Li on 2018/11/28.
//  Copyright © 2018 MuShare. All rights reserved.
//

import UIKit
import SnapKit

class MessageView: ShapeView {
    
    private struct Const {
        static let left: CGFloat = 80
        static let height: CGFloat = 20
    }
    
    lazy var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        
        drawShape = { [unowned self] path in
            let labelHeight = self.frame.height - Const.height
            let raduis = labelHeight / 2
            
            path.move(to: CGPoint(x: raduis, y: 0))
            path.addArc(withCenter: CGPoint(x: self.frame.width - raduis, y: raduis), radius: raduis, startAngle: -.pi / 2, endAngle: .pi / 2, clockwise: true)
            path.addLine(to: CGPoint(x: Const.left + Const.height, y: labelHeight))
            path.addLine(to: CGPoint(x: Const.left + Const.height / 2, y: self.frame.height))
            path.addLine(to: CGPoint(x: Const.left, y: labelHeight))
            path.addArc(withCenter: CGPoint(x: raduis, y: raduis), radius: raduis, startAngle: .pi / 2, endAngle: -.pi / 2, clockwise: true)
        }
        
        customizeShapeLayer = { layer in
            layer.shadowRadius = 5
            layer.shadowColor = UIColor.darkGray.cgColor
            layer.shadowOpacity = 1
            layer.shadowOffset = .zero
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-Const.height / 2)
            $0.left.equalToSuperview().offset(bounds.height / 2)
            $0.right.equalToSuperview().offset(-bounds.height / 2)
        }
    }
}


class ViewController: UIViewController {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = UIImage(named: "background.jpg")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var messageView: MessageView = {
        let view = MessageView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.7)
        view.label.text = "ShapeView Demo App"
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(backgroundImageView)
        view.addSubview(messageView)
        
        messageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(messageView.snp.width).multipliedBy(0.3)
        }
    }
    

}
