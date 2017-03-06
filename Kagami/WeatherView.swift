//
//  WeatherView.swift
//  Kagami
//
//  Created by Eric Chang on 3/6/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import SnapKit

class WeatherView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
     
        // add subviews
        self.addSubview(testButton)
        
        // configure constraints
        testButton.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    lazy var testButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = "Hello World"
        return button
    }()

}
