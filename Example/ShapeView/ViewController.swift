//
//  ViewController.swift
//  ShapeView
//
//  Created by Meng Li on 2018/11/28.
//  Copyright © 2018 MuShare. All rights reserved.
//

import UIKit
import SnapKit
import ShapeView
import Fakery

class MessageView: ShapeView {
    
    private struct Const {
        static let left: CGFloat = 80
        static let height: CGFloat = 20
    }
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(button)

        path = .custom { [unowned self] in
            let labelHeight = self.frame.height - Const.height
            let raduis = labelHeight / 2
            
            $0.move(to: CGPoint(x: raduis, y: 0))
            $0.addArc(
                withCenter: CGPoint(x: self.frame.width - raduis, y: raduis),
                radius: raduis,
                startAngle: -.pi / 2,
                endAngle: .pi / 2,
                clockwise: true
            )
            $0.addLine(to: CGPoint(x: Const.left + Const.height, y: labelHeight))
            $0.addLine(to: CGPoint(x: Const.left + Const.height / 2, y: self.frame.height))
            $0.addLine(to: CGPoint(x: Const.left, y: labelHeight))
            $0.addArc(
                withCenter: CGPoint(x: raduis, y: raduis),
                radius: raduis,
                startAngle: .pi / 2,
                endAngle: -.pi / 2,
                clockwise: true
            )
        }

        outerShadow = ShapeShadow(radius: 20, color: .green)
        innerShadow = ShapeShadow(radius: 20, color: .green)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        button.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-Const.height / 2)
            $0.left.equalToSuperview().offset(bounds.height / 2)
            $0.right.equalToSuperview().offset(-bounds.height / 2)
        }
    }
}

class ErrorView: UIView {

    private struct Const {
        static let left: CGFloat = 80
        static let height: CGFloat = 20
    }

    lazy var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)
        clipsToBounds = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let labelHeight = self.frame.height - Const.height
        let raduis = labelHeight / 2

        let path = UIBezierPath()
        path.move(to: CGPoint(x: raduis, y: 0))
        path.addArc(
            withCenter: CGPoint(x: self.frame.width - raduis, y: raduis),
            radius: raduis,
            startAngle: -.pi / 2,
            endAngle: .pi / 2,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: Const.left + Const.height, y: labelHeight))
        path.addLine(to: CGPoint(x: Const.left + Const.height / 2, y: self.frame.height))
        path.addLine(to: CGPoint(x: Const.left, y: labelHeight))
        path.addArc(
            withCenter: CGPoint(x: raduis, y: raduis),
            radius: raduis,
            startAngle: .pi / 2,
            endAngle: -.pi / 2,
            clockwise: true
        )
        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.shadowColor = UIColor.green.cgColor
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowOffset = .zero
        shapeLayer.shadowOpacity = 1

        layer.masksToBounds = true
        layer.mask = shapeLayer
//        layer.addSublayer(shapeLayer)

        label.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-Const.height / 2)
            $0.left.equalToSuperview().offset(bounds.height / 2)
            $0.right.equalToSuperview().offset(-bounds.height / 2)
        }
    }
}

class CustomView: ShapeView {
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Inner Button", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview().multipliedBy(0.5)
        }
        
        path = .custom { [unowned self] in
            let bounds = self.bounds
            $0.move(to: CGPoint(x: 0, y: 0))
            $0.addLine(to: CGPoint(x: bounds.width / 2 - 20, y: 0))
            $0.addLine(to: CGPoint(x: bounds.width / 2, y: 30))
            $0.addLine(to: CGPoint(x: bounds.width, y: 30))
            $0.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
            $0.addLine(to: CGPoint(x: 0, y: bounds.height))
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ViewController: UIViewController {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background.jpg")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var messageView: MessageView = {
        let view = MessageView(frame: .zero)
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.effect = UIBlurEffect(style: .regular)
        view.effectAlpha = 0.7
        view.button.setTitle("ShapeView Demo App", for: .normal)
        return view
    }()

    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.8)
        view.label.text = "ShapeView Error Demo"
        return view
    }()
    
    private lazy var customView: CustomView = {
        let view = CustomView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        view.innerShadow = ShapeShadow(radius: 8, color: .white)
        view.outerShadow = ShapeShadow(radius: 8, color: .white)
        view.effect = UIBlurEffect(style: .dark)
        view.effectAlpha = 0.8
        return view
    }()
    
    private lazy var starView: ShapeView = {
        let view = ShapeView()
        view.path = .star(vertex: 5) { [unowned view] in
            view.bounds
        }
        view.backgroundColor = .yellow
        view.outerShadow = ShapeShadow(radius: 8, color: .white)
        return view
    }()
    
    private lazy var cuteMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Message Test";
        label.textColor = .white
        return label
    }()
    
    private lazy var cuteDialogView: ShapeView = {
        let view = ShapeView()
        view.path = .cuteDialog(radius: 10, arrowPosition: .leftBottom(width: 60, height: 15)) { [unowned view] in
            view.bounds
        }
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        view.outerShadow = ShapeShadow(radius: 8, color: .white)
        view.effect = UIBlurEffect(style: .dark)
        view.effectAlpha = 0.8
        view.addSubview(cuteMessageLabel)
        return view
    }()
    
    private lazy var updateMessageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Update Message", for: .normal)
        button.addTarget(self, action: #selector(updateMessage), for: .touchUpInside)
        return button
    }()
    
    private lazy var stripeView: ShapeView = {
        let view = ShapeView()
        view.path = .stripe(width: 10, angle:  3 * .pi / 4) { [unowned self] in
            view.bounds
        }
        view.backgroundColor = .lightText
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(backgroundImageView)
        view.addSubview(messageView)
        view.addSubview(errorView)
        view.addSubview(customView)
        view.addSubview(starView)
        view.addSubview(cuteDialogView)
        view.addSubview(updateMessageButton)
        view.addSubview(stripeView)
        createConstraints()
        
    }
    
    private func createConstraints() {
        
        backgroundImageView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }

        messageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(50)
            $0.right.equalToSuperview().offset(-50)
            $0.height.equalTo(80)
            $0.top.equalToSuperview().offset(70)
           
        }
        
        errorView.snp.makeConstraints {
            $0.centerX.equalTo(messageView)
            $0.size.equalTo(messageView)
            $0.top.equalTo(messageView.snp.bottom).offset(20)
        }

        customView.snp.makeConstraints {
            $0.centerX.equalTo(messageView)
            $0.size.equalTo(messageView)
            $0.top.equalTo(errorView.snp.bottom).offset(20)
        }

        starView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(50)
            $0.top.equalTo(customView.snp.bottom).offset(20)
        }
        
        cuteDialogView.snp.makeConstraints {
            $0.left.equalTo(messageView)
            $0.top.equalTo(starView.snp.bottom).offset(20)
        }
        
        cuteMessageLabel.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-30)
        }
        
        updateMessageButton.snp.makeConstraints {
            $0.left.equalTo(messageView)
            $0.top.equalTo(cuteDialogView.snp.bottom).offset(20)
        }
        
        stripeView.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(updateMessageButton.snp.bottom).offset(20)
        }

    }

    @objc private func updateMessage() {
        let faker = Faker()
        cuteMessageLabel.text = faker.address.streetAddress()
    }
    
}
