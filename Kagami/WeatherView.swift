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
        self.backgroundColor = .red
        // configure constraints
        testButton.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(100.0)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func flashButtonClicked(sender: UIButton) {
        print("Hello World")
        self.removeFromSuperview()
    }
    
    lazy var testButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = "Hello World"
        button.setImage(#imageLiteral(resourceName: "Flash_Logo_01"), for: .normal)
        button.addTarget(SettingsViewController() , action: #selector(flashButtonClicked(sender:)), for: .touchUpInside)
        return button
    }()

}
