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
            $0.addArc(withCenter: CGPoint(x: self.frame.width - raduis, y: raduis), radius: raduis, startAngle: -.pi / 2, endAngle: .pi / 2, clockwise: true)
            $0.addLine(to: CGPoint(x: Const.left + Const.height, y: labelHeight))
            $0.addLine(to: CGPoint(x: Const.left + Const.height / 2, y: self.frame.height))
            $0.addLine(to: CGPoint(x: Const.left, y: labelHeight))
            $0.addArc(withCenter: CGPoint(x: raduis, y: raduis), radius: raduis, startAngle: .pi / 2, endAngle: -.pi / 2, clockwise: true)
        }

        outerShadow = ShapeShadow(raduis: 20, color: .green)
        innerShadow = ShapeShadow(raduis: 20, color: .green)
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
        path.addArc(withCenter: CGPoint(x: self.frame.width - raduis, y: raduis), radius: raduis, startAngle: -.pi / 2, endAngle: .pi / 2, clockwise: true)
        path.addLine(to: CGPoint(x: Const.left + Const.height, y: labelHeight))
        path.addLine(to: CGPoint(x: Const.left + Const.height / 2, y: self.frame.height))
        path.addLine(to: CGPoint(x: Const.left, y: labelHeight))
        path.addArc(withCenter: CGPoint(x: raduis, y: raduis), radius: raduis, startAngle: .pi / 2, endAngle: -.pi / 2, clockwise: true)
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
        view.blurEffectStyle = .regular
        view.blurAlpha = 0.7
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
        view.innerShadow = ShapeShadow(raduis: 8, color: .white)
        view.outerShadow = ShapeShadow(raduis: 8, color: .white)
        view.blurEffectStyle = .dark
        view.blurAlpha = 0.1
        return view
    }()
    
    private lazy var starView: ShapeView = {
        let view = ShapeView()
        view.path = .star(vertex: 5) { [unowned view] in
            return view.bounds
        }
        view.backgroundColor = .yellow
        view.outerShadow = ShapeShadow(raduis: 8, color: .white)
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 100
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(backgroundImageView)
        view.addSubview(messageView)
        view.addSubview(errorView)
        view.addSubview(customView)
        view.addSubview(starView)
        view.addSubview(tableView)
        createConstraints()
        
        starView.isHidden = true
        /**
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
         */
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
        
        tableView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(starView.snp.bottom).offset(20)
        }
        
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    
}

