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

class KagamiViewController: UIViewController, WidgetViewProtocol {
    
    // MARK: - Properties
    var ref: FIRDatabaseReference!
    let userDefaults = UserDefaults.standard
    var propertyAnimator: UIViewPropertyAnimator?
    
    var panRecognizer = UIPanGestureRecognizer()
    var tapRecognizer = UITapGestureRecognizer()
    
    var previousPoint: CGPoint?
    var widgetBeingEdited: UIView?
    var widgetViews: [WidgetView]

    var didTapWidget: () -> () = { }
    
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
            self.view.addSubview(widgetView)
            widgetView.backgroundColor = .red
            
            widgetView.doneButton.addTarget(self, action: #selector(save), for: .touchDown)
            widgetView.cancelButton.addTarget(self, action: #selector(save), for: .touchDown)
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
                make.height.equalTo(50.0)
                make.width.equalToSuperview().multipliedBy(0.125)
                make.leading.equalToSuperview().offset((50 * count) + 16)
                make.center.equalToSuperview()
            })
            count += 1
        }
        
//        for widgetView in widgetViews {
//            
//            widgetView.isUserInteractionEnabled = true
//            self.view.addSubview(widgetView)
//            
//            let widgetDict = userDefault.dictionary(forKey: widgetView.accessibilityIdentifier!)
//            
//            if widgetDict != nil {
//                
//                if widgetDict?["onMirror"] as! Bool == true {
//                    let x = widgetDict?["x"] as! CGFloat
//                    let y = widgetDict?["y"] as! CGFloat
//                    widgetView.subviews[0].alpha = 0.0
//                    widgetView.subviews[1].alpha = 1.0
//                    widgetView.snp.makeConstraints({ (make) in
//                        make.center.equalTo(CGPoint(x: x, y: y))
//                        make.height.width.equalTo(50.0)
//                    })
//                }
//                else {
//                    if widgetDict?["onMirror"] as! Bool == false {
//                        widgetView.snp.makeConstraints({ (make) in
//                            make.bottom.equalTo(iconContainerView.snp.bottom).offset(-5.0)
//                            make.width.height.equalTo(50.0)
//                            make.leading.equalTo(iconContainerView.snp.leading).offset((widgetView.tag * 50) + (8 * widgetView.tag) + 8)
//                        })
//                        
//                    }
//                }
//            }
//            else {
//                widgetView.snp.makeConstraints { (make) in
//                    make.bottom.equalTo(iconContainerView.snp.bottom).offset(-5.0)
//                    make.width.height.equalTo(50.0)
//                    make.leading.equalTo(iconContainerView.snp.leading).offset((widgetView.tag * 50) + (8 * widgetView.tag) + 8)
//                }
//            }
//        }
    }
    
    // MARK: - WidgetView Delegate methods
    func layoutWidgetView(widgetView: WidgetView) {
        
        let center = widgetView.convert(widgetView.center, from: widgetView.superview)
        let topLeft = widgetView.convert(CGPoint(x: widgetView.bounds.minX, y: widgetView.bounds.minY), from: kagamiView)
        let topRight = widgetView.convert(CGPoint(x: widgetView.bounds.maxX, y: widgetView.bounds.minY), from: kagamiView)
        let bottomRight = widgetView.convert(CGPoint(x: widgetView.bounds.maxX, y: widgetView.bounds.maxY), from: kagamiView)
        let bottomLeft = widgetView.convert(CGPoint(x: widgetView.bounds.minX, y: widgetView.bounds.maxY), from: kagamiView)
        
        if kagamiView.bounds.contains(topLeft),
            kagamiView.bounds.contains(topRight),
            kagamiView.bounds.contains(bottomRight),
            kagamiView.bounds.contains(bottomLeft) {
            kagamiView.addSubview(widgetView)
            widgetView.snp.remakeConstraints({ (make) in
                make.center.equalTo(center)
                make.height.width.equalTo(50.0)
            })
            kagamiView.layoutSubviews()
            userDefaults.set(["onMirror" : true, "x" : widgetView.frame.midX, "y" : widgetView.frame.midY], forKey: widgetView.description)
            
            let widgetNode = ref.child((widgetView.widget.description))
            widgetNode.updateChildValues(["x" : (widgetView.frame.minX / kagamiView.frame.maxX) , "y" : (widgetView.frame.minY / kagamiView.bounds.maxY), "onMirror" : true])
            
            widgetBeingEdited = widgetView
        }
        else {
            widgetView.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview().offset(-5.0)
                make.width.height.equalTo(50.0)
                make.leading.equalToSuperview().offset((widgetView.tag * 50) + (8 * widgetView.tag) + 8)
            }
            userDefaults.set(["onMirror" : false, "x" : widgetView.frame.midX, "y" : widgetView.frame.midY], forKey: widgetView.widget.description)
            ref.child(widgetView.widget.description).updateChildValues(["onMirror" : false])
        }
    }
    
    // MARK: - Save custom settings
    //TODO: - Migrate to seperate file
    func save() {
        
        //this is bad but quick solution
        let widgetView = widgetBeingEdited
        
        // save to firebase

        propertyAnimator?.addAnimations {
            
            widgetView?.snp.remakeConstraints({ (make) in
                make.size.equalTo(0.1)
                make.center.equalTo(self.view.snp.center)
            })
            self.view.layoutIfNeeded()
        }
        self.kagamiView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        propertyAnimator?.startAnimation()
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
  
    lazy var weatherView: WeatherView = {
        let view = WeatherView()
        view.layer.opacity = 0.0
        view.clipsToBounds = true
        return view
    }()
    
    lazy var forecastView: ForecastView = {
        let view = ForecastView()
        view.layer.opacity = 0.0
        view.clipsToBounds = true
        return view
    }()
    
    lazy var timeView: TimeView = {
        let view = TimeView(widget: Time(militaryTime: true))
        view.layer.opacity = 0.0
        view.clipsToBounds = true
        return view
    }()
    
    lazy var toDoView: ToDoView = {
        let view = ToDoView()
        view.layer.opacity = 1.0
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
    }()
    
    lazy var quoteView: QuoteView = {
        let view = QuoteView()
        view.layer.opacity = 1.0
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
    }()
  
    lazy var mirrorAnimationView: LOTAnimationView = {
      var view: LOTAnimationView = LOTAnimationView(name: "KagamiMirrorAnimation")
      view.contentMode = .scaleAspectFill
    
      return view
    }()
}

// Ignore for now
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



