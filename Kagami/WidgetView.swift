//
//  WidgetView.swift
//  Kagami
//
//  Created by Eric Chang on 3/13/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit

protocol WidgetViewable: class {
    var panRecognizer: UIPanGestureRecognizer { get set }
    var tapRecognizer: UITapGestureRecognizer { get set }
    var propertyAnimator: UIViewPropertyAnimator? { get set }
    var userDefaults: UserDefaults? { get set }
    
    func setupAnimationConstraint()
    
    func setPanGestureRecognizer() -> UIPanGestureRecognizer
    func setTapRecognizer() -> UITapGestureRecognizer
    func wasTapped(_ gesture: UITapGestureRecognizer)
    func wasDragged(_ gesture: UIPanGestureRecognizer)
}

extension WidgetViewable {
    
    
}

class WidgetView: UIView, WidgetViewable {
    
    internal var userDefaults: UserDefaults?
    internal var propertyAnimator: UIViewPropertyAnimator?
    internal var tapRecognizer = UITapGestureRecognizer()
    internal var panRecognizer = UIPanGestureRecognizer()

    // MARK: - Properties
    var widget: Widgetable
    let kagami = KagamiViewController()
    var iconImageView: UIImageView?
    var widgetImageView: UIImageView?
    weak var delegate: WidgetViewable?
    
    func setupAnimationConstraint() {
        self.snp.remakeConstraints({ (make) in
            make.height.width.equalToSuperview().multipliedBy(0.8)
            make.center.equalToSuperview()
        })
        
        self.layer.opacity = 1.0
        
        self.layoutIfNeeded()
    }
    
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
        
        let view = gesture.view!
        
        if gesture.state == .ended {
            
            
            
            propertyAnimator?.addAnimations ({
                self.setupAnimationConstraint()
            })
            
            propertyAnimator?.startAnimation()
        }
    }
    
    func wasDragged(_ gesture: UIPanGestureRecognizer) {

        let translation = gesture.translation(in: self)
        
        self.center = CGPoint(x: self.center.x + translation.x , y: self.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: self)
        
        //TODO: - MATH -- min > kagami.min && max < kagami.max
        
        if gesture.state == .began {
            dump("Parent View \(self.subviews.count)")
        }
        
        if gesture.state == .changed {
            dump("Label Center \(self.center) Translation: \(translation)")
        }
        
        if gesture.state == .ended {
            let kagamiView = kagami.kagamiView
            
            let centerOfLabel = self.convert(self.center, from: self.superview)
            let topLeft = self.convert((x: self.bounds.minX, y: self.bounds.minY), from: self.superview)
            
            
            if kagamiView?.bounds.contains(centerOfLabel) {
                self.kagamiView!.addSubview(self)
                self.snp.remakeConstraints({ (make) in
                    make.center.equalTo(centerOfLabel)
                    make.height.width.equalTo(50.0)
                })
                kagamiView.layoutSubviews()
                userDefaults.set(["onMirror" : true, "x" : self.frame.midX, "y" : self.frame.midY], forKey: self.accessibilityIdentifier!)
            }
            else {
                self.snp.makeConstraints { (make) in
                    make.bottom.equalToSuperview().offset(-5.0)
                    make.width.height.equalTo(50.0)
                    make.leading.equalToSuperview().offset((self.tag * 50) + (8 * self.tag) + 8)
                }
                userDefaults.set(["onMirror" : false, "x" : self.frame.midX, "y" : self.frame.midY], forKey: self.accessibilityIdentifier!)
                ref.child(self.accessibilityIdentifier!).updateChildValues(["onMirror" : false])
            }
            
            if kagamiView.bounds.contains(self) {
                let weatherNode = ref.child(self.widget.description)
                weatherNode.updateChildValues(["x" : (subView.frame.minX / kagamiView.frame.maxX) , "y" : (subView.frame.minY / kagamiView.bounds.maxY), "onMirror" : true])
                print("This Is \(subView.accessibilityIdentifier!)")
                print(subView.frame)
            }
        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

class WeatherWidgetView : WidgetView {
    
}
