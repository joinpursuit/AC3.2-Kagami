//
//  ClockViewController.swift
//  Kagami
//
//  Created by Eashir Arafat on 3/6/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import TwicketSegmentedControl

class TimeView: WidgetView, WidgetViewable {

    // MARK: - Properties
    var dockIcon: UIImage = #imageLiteral(resourceName: "clock")
    var mirrorIcon: UIImage = #imageLiteral(resourceName: "Flash_Logo_01")
    
    weak var delegate: WidgetViewable?
    
    
    override init(widget: Widgetable, settingsView: WidgetSettingsView) {
        super.init(widget: widget, settingsView: settingsView)
        self.backgroundColor = .clear
        self.alpha = 0.8
        self.layer.cornerRadius = 9
        
        self.widget = widget
        
        setupViewHierarchy()
        setupSubviews()
        configureConstraints()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // MARK: Setup
    func setupViewHierarchy () {
        self.dockView.image = dockIcon
//        self.addSubview(mirrorImageView)
        
        self.addGestureRecognizer(setTapRecognizer())
        self.addGestureRecognizer(setPanGestureRecognizer())
    }
    
    private func setupSubviews() {
        setupDockImageView()
        setupMirrorImageView()
    }
    
    private func setupDockImageView() {
        dockView.image = dockIcon
    }
    
    private func setupMirrorImageView() {
        mirrorView.image = mirrorIcon
    }
    
    func configureConstraints() {
        
//        dockImageView.snp.remakeConstraints { (make) in
//            make.size.equalTo(50.0)
//            make.center.equalToSuperview()
//        }
//        
//        mirrorImageView.snp.remakeConstraints { (make) in
//            make.size.equalTo(0.1)
//            make.center.equalToSuperview()
//        }
    }
    
}
