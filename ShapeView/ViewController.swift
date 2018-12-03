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

        path = .custom {
            let labelHeight = self.frame.height - Const.height
            let raduis = labelHeight / 2
            
            $0.move(to: CGPoint(x: raduis, y: 0))
            $0.addArc(withCenter: CGPoint(x: self.frame.width - raduis, y: raduis), radius: raduis, startAngle: -.pi / 2, endAngle: .pi / 2, clockwise: true)
            $0.addLine(to: CGPoint(x: Const.left + Const.height, y: labelHeight))
            $0.addLine(to: CGPoint(x: Const.left + Const.height / 2, y: self.frame.height))
            $0.addLine(to: CGPoint(x: Const.left, y: labelHeight))
            $0.addArc(withCenter: CGPoint(x: raduis, y: raduis), radius: raduis, startAngle: .pi / 2, endAngle: -.pi / 2, clockwise: true)
        }
        
        shadowRadius = 20
        shadowColor = .green
        blurEffectStyle = .regular
        blurAlpha = 1
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
        view.backgroundColor = UIColor(white: 1, alpha: 0.1)
        view.label.text = "ShapeView Demo App"
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(backgroundImageView)
        view.addSubview(messageView)
        createConstraints()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.messageView.shadowColor = .darkGray
            self.messageView.shaowOffset = CGSize(width: 10, height: 10)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.messageView.blurEffectStyle = .dark
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.messageView.path = .corner(radius: 10) {
                return self.messageView.bounds
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.messageView.blurAlpha = 0.5
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.messageView.path = .dialog(radius: 10, arrowPosition: .right(center: 50, width: 40, height: 20)) {
                return self.messageView.bounds
            }
        }
    }
    
    private func createConstraints() {
        messageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(messageView.snp.width).multipliedBy(0.3)
        }
    }

}
