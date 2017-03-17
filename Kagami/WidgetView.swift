//
//  WidgetView.swift
//  Kagami
//
//  Created by Eric Chang on 3/13/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol WidgetViewable: class {
    var panRecognizer: UIPanGestureRecognizer { get set }
    var tapRecognizer: UITapGestureRecognizer { get set }
    var propertyAnimator: UIViewPropertyAnimator? { get set }
    var userDefaults: UserDefaults { get set }
    
    var mirrorIcon: UIImage { get set }
    var dockIcon: UIImage { get set }
    
}

protocol WidgetViewProtocol: class {
    func layoutWidgetView(widgetView: WidgetView)
    func save()
}

class WidgetView: UIView {
    
    // MARK: - Properties
    internal var userDefaults = UserDefaults.standard
    internal var propertyAnimator: UIViewPropertyAnimator?
    internal var tapRecognizer = UITapGestureRecognizer()
    internal var panRecognizer = UIPanGestureRecognizer()
    var ref: FIRDatabaseReference!

    var widget: Widgetable
    var mirrorView = UIImageView()
    var dockView = UIImageView()
    weak var viewDelegate: WidgetViewProtocol?
    var settingsView : WidgetSettingsView

    
    init(widget: Widgetable, settingsView: WidgetSettingsView) {
        self.widget = widget
        self.settingsView = settingsView
        
        ref = FIRDatabase.database().reference()
        propertyAnimator = UIViewPropertyAnimator(duration: 0.75, dampingRatio: 0.77, animations: nil)
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        setupViewHierarchy()
        configureConstraints()
    }
    
    // below init is for storyboard, however this will cause no widget init. 
    // user programmatic only
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViewHierarchy() {
        self.addSubview(mirrorView)
        self.addSubview(dockView)
//        self.addSubview(settingsView)
    }
    
    private func configureConstraints() {
        dockView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }

        mirrorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(0.1)
        }
//        
//        settingsView.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//            make.size.equalTo(0.1)
//        }
    }
    
    // MARK: - Settings Animations
    func setupAnimationConstraint() {
        self.snp.remakeConstraints({ (make) in
            make.height.width.equalToSuperview().multipliedBy(0.8)
            make.center.equalToSuperview()
        })
        
        self.layer.opacity = 1.0
        
        self.layoutIfNeeded()
    }
    
    // MARK: - Drag and Drop
    func setPanGestureRecognizer() -> UIPanGestureRecognizer {
        panRecognizer = UIPanGestureRecognizer (target: self, action: #selector(wasDragged(_:)))
        panRecognizer.minimumNumberOfTouches = 1
        panRecognizer.maximumNumberOfTouches = 1
        panRecognizer.cancelsTouchesInView = false
        return panRecognizer
    }
    
    func setTapRecognizer() -> UITapGestureRecognizer {
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(wasTapped(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.cancelsTouchesInView = false
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.require(toFail: panRecognizer)
        return tapRecognizer
    }

    func wasTapped(_ gesture: UITapGestureRecognizer) {
        
        let widgetView = gesture.view as! WidgetViewable
        
        //TODO: - Link widgetSettingsView to widgetView here in order to expand settings view
        if gesture.state == .ended {
            
            propertyAnimator?.addAnimations ({
                self.viewDelegate?.layoutWidgetView(widgetView: self)
            })
            
            propertyAnimator?.startAnimation()
        }
    }
    
    func wasDragged(_ gesture: UIPanGestureRecognizer) {

        let translation = gesture.translation(in: self)
        
        self.center = CGPoint(x: self.center.x + translation.x , y: self.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: self)
        
        if gesture.state == .began {
            dump("Parent View \(self.subviews.count)")
        }
        
        if gesture.state == .changed {
            dump("Label Center \(self.center) Translation: \(translation)")
        }
        
        if gesture.state == .ended {
           // self.viewDelegate?.layoutWidgetView(widgetView: self)
        }
    }
 }
