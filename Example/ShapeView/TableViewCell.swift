//
//  TableViewCell.swift
//  ShapeView_Example
//
//  Created by Meng Li on 2019/02/20.
//  Copyright © 2019 MuShare. All rights reserved.
//

import UIKit
import ShapeView

class TableViewCell: UITableViewCell {
    
    private lazy var starView: ShapeView = {
        let view = ShapeView()
        view.path = .star(vertex: 5, extrusion: 13) {
            return view.bounds
        }
        view.backgroundColor = .yellow
        view.outerShadow = ShapeShadow(radius: 5, color: .lightGray)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        addSubview(starView)
        starView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(50)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
