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
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "か が み"
        
        setupViewHierarchy()
        addTargets()
        setupWeather()
        // Developer testing only -> REMOVE before production
        // Developer testing only -> REMOVE before production
        ref = FIRDatabase.database().reference()
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
//        self.ref.child("position").updateChildValues(["topLeft" : "true"])
        reference.setValue(["topLeft" : "weather",
                            "topRight" : "time",
                            "middle" : "news",
                            "bottom" : "quote"])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        testView.removeFromSuperview()
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
        view.addSubview(annieButton)
        
        hamburger.addSubview(burgerBar1)
        hamburger.addSubview(burgerBar2)
        hamburger.addSubview(burgerBar3)
        
        kagamiView.addSubview(topLeftSelection)
        kagamiView.addSubview(topRightSelection)
        kagamiView.addSubview(middleSelection)
        kagamiView.addSubview(bottomSelection)
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
        
        // mirror view
        kagamiView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview().multipliedBy(0.75)
            make.bottom.equalToSuperview().inset(44.0)
            make.centerX.equalToSuperview()
        }
        
        // selections
        topLeftSelection.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().inset(16.0)
            make.width.equalToSuperview().multipliedBy(0.30)
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        
        topRightSelection.snp.makeConstraints { (make) in
            make.top.trailing.equalToSuperview().inset(16.0)
            make.width.equalToSuperview().multipliedBy(0.30)
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        
        middleSelection.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.5)
        }
        
        bottomSelection.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview().inset(16.0)
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        
        annieButton.snp.makeConstraints { (make) in
            make.top.trailing.equalToSuperview()
            make.height.equalTo(50.0)
            make.width.equalTo(100.0)
        }
    }
    
    // add targets
    func addTargets() {
        //hamburger
        hamburger.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(annieSegue)))
        
        // selections
        topLeftSelection.addTarget(self, action: #selector(annieSegue), for: .touchUpInside)
        topRightSelection.addTarget(self, action: #selector(annieSegue), for: .touchUpInside)
        middleSelection.addTarget(self, action: #selector(annieSegue), for: .touchUpInside)
        bottomSelection.addTarget(self, action: #selector(annieSegue), for: .touchUpInside)
        
        annieButton.addTarget(self, action: #selector(annieSegue), for: .touchUpInside)
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
    internal func move(view: UIView, to point: CGPoint) {
        let _ = dynamicAnimator?.behaviors.map {
            if $0 is UISnapBehavior {
                dynamicAnimator?.removeBehavior($0)
            }
        }
        
        let snapBehavior = UISnapBehavior(item: view, snapTo: point)
        snapBehavior.damping = 1.0
        dynamicAnimator?.addBehavior(snapBehavior)
        
    }
    
    internal func pickUp(view: UIView) {
        self.animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
            view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
        self.animator?.startAnimation()
        isCurrentlyHeld = true
    }
    
    internal func putDownView(view: UIView) {
        self.animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn) {
            view.transform = CGAffineTransform.identity
        }
        
        let _ = dynamicAnimator?.behaviors.map {
            if $0 is UISnapBehavior {
                dynamicAnimator?.removeBehavior($0)
            }
        }
        
        isCurrentlyHeld = false
        self.animator?.startAnimation()
    }
    
    // MARK: - Tracking Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let wasInsideBlueFrame = darkBlueView.frame.contains(touch.location(in: view))
        
        if wasInsideBlueFrame {
            pickUp(view: darkBlueView)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchLocationInView = touch.location(in: view)
        if isCurrentlyHeld {
            move(view: darkBlueView, to: touchLocationInView)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        putDownView(view: darkBlueView)
    }
    
    // MARK: - ChangeThisView
    internal lazy var darkBlueView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .blue
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
    
    // selections
    lazy var topLeftSelection: UIButton = {
        let button = UIButton()
        button.styled()
        return button
    }()
    
    lazy var topRightSelection: UIButton = {
        let button = UIButton()
        button.styled()
        return button
    }()
    
    lazy var middleSelection: UIButton = {
        let button = UIButton()
        button.styled()
        return button
    }()
    
    lazy var bottomSelection: UIButton = {
        let button = UIButton()
        button.styled()
        return button
    }()
    
    // Developer testing button
    lazy var annieButton: UIButton = {
        let button = UIButton()
        button.setTitle("Annie-chan", for: .normal)
        button.backgroundColor = .red
        return button
    }()
    
    lazy var testView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
}

extension KagamiViewController {
    
    func setupWeather() {
        self.view.addSubview(testView)
        
        testView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(50.0)
        }
    }
    
    
}

