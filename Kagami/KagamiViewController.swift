//
//  KagamiViewController.swift
//  Kagami
//
//  Created by Eric Chang on 2/28/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseDatabase

class KagamiViewController: UIViewController {
    
    // MARK: - Properties
    var ref: FIRDatabaseReference!
    var animator: UIViewPropertyAnimator? = nil
    var dynamicAnimator: UIDynamicAnimator? = nil
    var isCurrentlyHeld: Bool = false
    var blueViewOriginalPoint: CGPoint?
    var theCGPoint: CGPoint?
    var panRecognizer = UIPanGestureRecognizer()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "か が み"
        self.dynamicAnimator = UIDynamicAnimator(referenceView: view)
        
        setupViewHierarchy()
        addTargets()
        
        // Developer testing only -> REMOVE before production
        // Developer testing only -> REMOVE before production
        ref = FIRDatabase.database().reference()
        dump(self.view.subviews.count)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        configureConstraints()
        
        // Developer testing only -> REMOVE before production
        // Developer testing only -> REMOVE before production
        let reference = self.ref.child("position")
        reference.setValue(["topLeft" : "weather",
                            "topRight" : "time",
                            "middle" : "news",
                            "bottom" : "quote"])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let collisions = CollidingViewBehavior(items: [testRedView, testBlueView, testPurpleView])
//        self.dynamicAnimator?.addBehavior(collisions)
        
        self.blueViewOriginalPoint = testBlueView.center
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup View Hierarchy & Constraints
    // view hierarchy
    func setupViewHierarchy() {
        self.edgesForExtendedLayout = []
        
        
        view.backgroundColor = .white
        
        view.addSubview(hamburger)
        view.addSubview(kagamiView)
        view.addSubview(iconContainerView)
        
        iconContainerView.addSubview(testBlueView)
        iconContainerView.addSubview(testRedView)
        iconContainerView.addSubview(testPurpleView)
        
        testBlueView.addGestureRecognizer(setGestureRecognizer())
        testRedView.addGestureRecognizer(setGestureRecognizer())
        testPurpleView.addGestureRecognizer(setGestureRecognizer())
        
        hamburger.addSubview(burgerBar1)
        hamburger.addSubview(burgerBar2)
        hamburger.addSubview(burgerBar3)
    }
    
    // constraints
    func configureConstraints() {
        // hamburger
        hamburger.snp.makeConstraints { (make) in
            make.size.equalTo(30.0)
            make.top.equalToSuperview().offset(30.0)
            make.leading.equalToSuperview().offset(8.0)
        }
        
        burgerBar1.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.2)
            make.width.equalToSuperview().multipliedBy(1)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5.0)
        }
        
        burgerBar2.snp.makeConstraints { (make) in
            make.height.width.centerX.equalTo(burgerBar1)
            make.top.equalTo(burgerBar1.snp.bottom).offset(5.0)
        }
        
        burgerBar3.snp.makeConstraints { (make) in
            make.height.width.centerX.equalTo(burgerBar1)
            make.top.equalTo(burgerBar2.snp.bottom).offset(5.0)
        }
        
        // testing drag views
        iconContainerView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-8.0)
            make.top.equalToSuperview().offset(8.0)
            make.bottom.equalToSuperview().offset(-8.0)
            make.width.equalTo(60.0)
        }
        
        testBlueView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-5.0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50.0)
            
        }
        
        testRedView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-5.0)
            make.centerY.equalToSuperview().offset(70)
            make.width.height.equalTo(50.0)
        }
        
        testPurpleView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-5.0)
            make.centerY.equalToSuperview().offset(-70)
            make.width.height.equalTo(50.0)
        }
        
        
        // mirror view
        kagamiView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview().multipliedBy(0.75)
            make.centerY.equalToSuperview().inset(50.0)
            make.leading.equalToSuperview().offset(16.0)
        }
        
    }
    
    // add targets
    func addTargets() {
        //hamburger
        hamburger.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(annieSegue)))

    }
    
    // add gestures
    func setGestureRecognizer() -> UIPanGestureRecognizer {
        
        panRecognizer = UIPanGestureRecognizer (target: self, action: #selector(self.wasDragged(_:)))
        panRecognizer.minimumNumberOfTouches = 1
        panRecognizer.maximumNumberOfTouches = 1
        panRecognizer.cancelsTouchesInView = false
        return panRecognizer
    }
    
    
    func wasDragged(_ gesture: UIPanGestureRecognizer) {
        let label = gesture.view!
        let translation = gesture.translation(in: self.view)
//        let rect = self.kagamiView.frame
        label.center = CGPoint(x: label.center.x + translation.x , y: label.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: self.view)
        
        //TODO: - Math
        // viewMin >= kagamiMin & viewMax <= kagamiMax
        
        if gesture.state == .began {
            dump("Parent View \(self.view.subviews.count)")
            dump("Kagami View \(self.kagamiView.subviews.count)")
        }
        
        if gesture.state == .ended {
            
            let centerOfLabel = self.kagamiView.convert(label.center, from: label.superview)
            print(centerOfLabel)
            print(kagamiView.bounds)
            
            if kagamiView.bounds.contains(centerOfLabel) {
                self.kagamiView.addSubview(label)
                label.snp.remakeConstraints({ (make) in
                    make.center.equalTo(centerOfLabel)
                    make.height.width.equalTo(50.0)
                })
                
                dump("This the center of the label \(centerOfLabel)")
                
            }
            else {
                self.iconContainerView.addSubview(label)
                label.snp.remakeConstraints({ (make) in
                    make.trailing.equalToSuperview().offset(-5.0)
                    make.centerY.equalToSuperview()
                    make.height.width.equalTo(50.0)
                })
            }
        }
        
    }
    
    func annieSegue() {
        navigationController?.pushViewController(SelectionViewController(), animated: true)
        
        let backItem = UIBarButtonItem()
        backItem.tintColor = ColorPalette.whiteColor
        navigationController?.navigationBar.tintColor = ColorPalette.whiteColor
        navigationItem.backBarButtonItem = backItem
    }
    
    /**
     * Animations here! :) 👇👇👇
     */
    // MARK: - Movement

//    internal func move(view: UIView, to point: CGPoint) {
//        let _ = dynamicAnimator?.behaviors.map {
//            if $0 is UISnapBehavior {
//                dynamicAnimator?.removeBehavior($0)
//            }
//        }
//        
//        let snapBehavior = UISnapBehavior(item: view, snapTo: point)
//        snapBehavior.damping = 1.0
//        dynamicAnimator?.addBehavior(snapBehavior)
//        
//    }
//    
//    internal func pickUp(view: UIView) {
//        self.animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
//            view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//        }
//        
//        self.animator?.startAnimation()
//        isCurrentlyHeld = true
//    }
//    
//    internal func putDownView(view: UIView) {
//        self.animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn) {
//            view.transform = CGAffineTransform.identity
//        }
//        
//        let _ = dynamicAnimator?.behaviors.map {
//            if $0 is UISnapBehavior {
//                dynamicAnimator?.removeBehavior($0)
//            }
//        }
//        
//        isCurrentlyHeld = false
//        self.animator?.startAnimation()
//    }
//    
//    // MARK: - Tracking Touches
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let wasInsideBlueFrame = darkBlueView.frame.contains(touch.location(in: view))
//        
//        if wasInsideBlueFrame {
//            pickUp(view: darkBlueView)
//        }
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        
//        let touchLocationInView = touch.location(in: view)
//        if isCurrentlyHeld {
//            move(view: darkBlueView, to: touchLocationInView)
//        }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        dump(touches.count)
//    }
    
    // MARK: - Drag And Drop Testing
    
    internal lazy var iconContainerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    internal lazy var testBlueView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .blue
        view.isUserInteractionEnabled = true
        return view
    }()
    
    internal lazy var testRedView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .red
        view.isUserInteractionEnabled = true
        return view
    }()
    
    internal lazy var testPurpleView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .purple
        view.isUserInteractionEnabled = true
        return view
    }()
    /**
     * Animations here! :) ☝️☝️☝️
     */
    
    
    // MARK: - Lazy Instantiates
    // hamburger
    lazy var hamburger: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var burgerBar1: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.blackColor
        //        view.layer.cornerRadius = 5.0
        return view
    }()
    
    lazy var burgerBar2: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.blackColor
        //        view.layer.cornerRadius = 5.0
        return view
    }()
    
    lazy var burgerBar3: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.blackColor
        //        view.layer.cornerRadius = 5.0
        return view
    }()
    
    // kagami view
    lazy var kagamiView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.accentColor
        view.layer.borderColor = ColorPalette.blackColor.cgColor
        view.layer.borderWidth = 1.0
        view.alpha = 0.8
        return view
    }()
    
}

class CollidingViewBehavior: UIDynamicBehavior  {
    
    override init() {}
    
    convenience init(items: [UIDynamicItem]) {
        self.init()
        
        let collisionBehavior = UICollisionBehavior(items: items)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        self.addChildBehavior(collisionBehavior)
        
        let elasticBehavior = UIDynamicItemBehavior(items: items)
        elasticBehavior.elasticity = 0.0
        self.addChildBehavior(elasticBehavior)
        
    }
    
}



