//
//  KagamiViewController.swift
//  Kagami
//
//  Created by Eric Chang on 2/28/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import Lottie
import SnapKit
import FirebaseDatabase

// should be for dock if dock/mirror are put into own UIView class - separate from KVC
protocol KagamiViewControllerDataSource : class {
    var widgetViews: [WidgetView] { get set }
}

class KagamiViewController: UIViewController, WidgetViewProtocol {
    
    // MARK: - Properties
    var ref: FIRDatabaseReference!
    let userDefaults = UserDefaults.standard
    var propertyAnimator: UIViewPropertyAnimator?
    
    var panRecognizer = UIPanGestureRecognizer()
    var tapRecognizer = UITapGestureRecognizer()
    weak var delegate : KagamiViewControllerDataSource?
    
    var previousPoint: CGPoint?
    var widgetBeingEdited: WidgetView?
    internal var widgetViews: [WidgetView]
    
    // MARK: - View Lifecycle
    init(widgetViews: [WidgetView]) {
        self.widgetViews = widgetViews
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "鏡"
        mirrorAnimationView.play()
        propertyAnimator = UIViewPropertyAnimator(duration: 0.75, dampingRatio: 0.77, animations: nil)
        
        for widgetView in widgetViews {
            widgetView.viewDelegate = self
            widgetView.settingsView.doneButton.addTarget(self, action: #selector(save), for: .touchUpInside)
            
            widgetView.dockView.image = widgetView.widget.iconImage
        }
        
        setupViewHierarchy()
        
        ref = FIRDatabase.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
        
        configureConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        propertyAnimator = nil
    }
    
    // MARK: - Setup View Hierarchy & Constraints
    private func setupViewHierarchy() {
        
        view.backgroundColor = .white
        view.addSubview(mirrorImageView)
        view.addSubview(mirrorAnimationView)
        view.addSubview(kagamiView)
        view.addSubview(iconContainerView)
        
        for widgetView in widgetViews {
            view.addSubview(widgetView)
        }
    }
    
    private func configureConstraints() {
        // mirror view
        kagamiView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(iconContainerView.snp.top)
        }
        
        mirrorImageView.snp.makeConstraints({ (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(iconContainerView.snp.top)
        })
        
        mirrorAnimationView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(iconContainerView.snp.top)
        }
        
        // widget dock
        iconContainerView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(60.0)
        }
        
        // instantiate Widgets
        
        for widgetView in widgetViews {
            var count = 0
            widgetView.snp.remakeConstraints({ (make) in
                make.size.equalTo(50.0)
                make.leading.equalToSuperview().offset((50 * count) + 8)
                make.bottom.equalToSuperview().inset(4.0)
            })
            count += 1
        }
        }
    
    // MARK: - WidgetView Delegate methods
    func layoutWidgetView(widgetView: WidgetView) {
        
        widgetBeingEdited = widgetView
        
        let center = kagamiView.convert(widgetView.center, from: widgetView.superview)
        previousPoint = center
        widgetView.tapRecognizer.isEnabled = false
        //        let topLeft = widgetView.convert(CGPoint(x: widgetView.bounds.minX, y: widgetView.bounds.minY), from: kagamiView)
        //        let topRight = widgetView.convert(CGPoint(x: widgetView.bounds.maxX, y: widgetView.bounds.minY), from: kagamiView)
        //        let bottomRight = widgetView.convert(CGPoint(x: widgetView.bounds.maxX, y: widgetView.bounds.maxY), from: kagamiView)
        //        let bottomLeft = widgetView.convert(CGPoint(x: widgetView.bounds.minX, y: widgetView.bounds.maxY), from: kagamiView)
        
        //        if kagamiView.bounds.minX < widgetView.frame.minX,
        //            kagamiView.bounds.minY < widgetView.frame.minY,
        //            kagamiView.bounds.maxX > widgetView.frame.maxX,
        //            kagamiView.bounds.maxY > widgetView.frame.maxY {
        
        view.addSubview(widgetView.settingsView)
        widgetView.settingsView.isHidden = false
        widgetView.settingsView.snp.makeConstraints({ (make) in
            make.center.equalTo(self.view)
            make.height.width.equalTo(self.view).multipliedBy(0.8)
        })
        
        userDefaults.set(["onMirror" : true, "x" : widgetView.frame.midX, "y" : widgetView.frame.midY], forKey: widgetView.widget.description)
        
        let widgetNode = ref.child((widgetView.widget.description))
        widgetNode.updateChildValues(["x" : (widgetView.frame.minX / kagamiView.frame.maxX) , "y" : (widgetView.frame.minY / kagamiView.bounds.maxY), "onMirror" : true])
        //        }
        //        else {
        //            widgetView.snp.makeConstraints { (make) in
        //                make.bottom.equalToSuperview().offset(-5.0)
        //                make.width.height.equalTo(50.0)
        //                make.leading.equalToSuperview().offset((widgetView.tag * 50) + (8 * widgetView.tag) + 8)
        //            }
        //            userDefaults.set(["onMirror" : false, "x" : widgetView.frame.midX, "y" : widgetView.frame.midY], forKey: widgetView.widget.description)
        //            ref.child(widgetView.widget.description).updateChildValues(["onMirror" : false])
        
    }
    
    // MARK: - Save custom settings
    //TODO: - Migrate to seperate file
    func save() {
        
        //this is bad but quick solution
        guard let widgetView = widgetBeingEdited,
            let previousPoint = previousPoint else { return }
        
        for subView in (widgetView.subviews) {
            if subView != widgetView.dockView || subView != widgetView.mirrorView {
                subView.removeFromSuperview()
            }
        }
        
        //        widgetView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        
        //        widgetView.addSubview(widgetView.dockView)
        propertyAnimator?.addAnimations {
            
            widgetView.settingsView.isHidden = true
            
            //            widgetView.bringSubview(toFront: widgetView.dockView)
            self.view?.layoutIfNeeded()
        }
        self.kagamiView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        propertyAnimator?.startAnimation()
        widgetView.tapRecognizer.isEnabled = true
    }

    // MARK: - Lazy Instantiates
    
    lazy var kagamiView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        return view
    }()
    
    lazy var mirrorImageView: UIImageView = {
        let image = UIImage(named: "mirror2")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var iconContainerView: UIView = {
        let view: UIView = UIView()
        let offset = CGSize(width: 3.0, height: 5.0)
        view.backgroundColor = ColorPalette.whiteColor.withAlphaComponent(5)
        view.layer.masksToBounds = false
        view.layer.shadowOffset = offset
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 7.0
        view.layer.shouldRasterize = true
        return view
    }()
    
    lazy var mirrorAnimationView: LOTAnimationView = {
        var view: LOTAnimationView = LOTAnimationView(name: "KagamiMirrorAnimation")
        view.contentMode = .scaleAspectFill
        return view
    }()
}



