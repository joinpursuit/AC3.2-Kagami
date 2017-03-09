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

struct Widget {
    
    var category : Category
    
    init(category: Category) {
        self.category = category
    }
    
    enum Category : Int {
        case weather, time, todos
        
        var icon : UIImage {
            switch self {
            case .weather: return UIImage(named: "Flash_Logo_01")!
            case .time: return UIImage(named: "Watch-50")!
            case .todos: return UIImage(named: "Appointment Reminders-50")!
            }
        }
        
        var description : String {
            switch self {
            case .weather: return "weather"
            case .time: return "time"
            case .todos: return "toDos"
            }
        }
    }
    let imageView = UIImageView()
}



class KagamiViewController: UIViewController {
    
    // MARK: - Properties
    var ref: FIRDatabaseReference!
    let userDefault = UserDefaults.standard
    var propertyAnimator: UIViewPropertyAnimator?
    
    var panRecognizer = UIPanGestureRecognizer()
    var tapRecognizer = UITapGestureRecognizer()
    
    var widgetArray = [Widget(category: .weather), Widget(category: .time), Widget(category: .todos)]
    var previousPoint: CGPoint?
    var didTapWidget: () -> () = { }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "鏡"
        propertyAnimator = UIViewPropertyAnimator(duration: 2.0, dampingRatio: 0.75, animations: nil)
        
        setupViewHierarchy()
        
        ref = FIRDatabase.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
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
        
        view.addSubview(kagamiView)
        view.addSubview(iconContainerView)
        view.addSubview(toDoView)
        
        //        hamburger.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(annieSegue)))
    }
    
    private func configureConstraints() {
        // mirror view
        kagamiView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(22.0)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(iconContainerView.snp.top)
        }
        
        // widget dock
        iconContainerView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(60.0)
        }
        
        // instantiate Widgets
        for widget in widgetArray {
            
            let imageView = widget.imageView
            imageView.image = widget.category.icon
            //            imageView.layer.borderColor = ColorPalette.blackColor.cgColor
            //            imageView.layer.borderWidth = 1.0
            imageView.alpha = 0.8
            imageView.tag = widget.category.rawValue
            imageView.accessibilityIdentifier = widget.category.description
            
            imageView.addGestureRecognizer(setPanGestureRecognizer())
            imageView.addGestureRecognizer(setTapRecognizer())
            imageView.isUserInteractionEnabled = true
            iconContainerView.addSubview(imageView)
            
            let widgetDict = userDefault.dictionary(forKey: imageView.accessibilityIdentifier!)
            
            if widgetDict != nil {
                if widgetDict?["onMirror"] as! Bool == true {
                    let x = widgetDict?["x"] as! CGFloat
                    let y = widgetDict?["y"] as! CGFloat
                    self.kagamiView.addSubview(imageView)
                    imageView.snp.makeConstraints({ (make) in
                        make.center.equalTo(CGPoint(x: x, y: y))
                        make.height.width.equalTo(50.0)
                    })
                } else {
                    if widgetDict?["onMirror"] as! Bool == false {
                        
                        self.iconContainerView.addSubview(imageView)
                        imageView.snp.makeConstraints({ (make) in
                            make.leading.equalToSuperview().offset((imageView.tag * 50) + (8 * imageView.tag) + 8)
                            make.bottom.equalToSuperview().offset(-5.0)
                            make.height.width.equalTo(50.0)
                        })
                        
                    }
                }
            }
            else {
                imageView.snp.makeConstraints { (make) in
                    make.bottom.equalToSuperview().offset(-5.0)
                    make.width.height.equalTo(50.0)
                    make.leading.equalToSuperview().offset((imageView.tag * 50) + (8 * imageView.tag) + 8)
                }
            }
            
        }
        
        toDoView.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.size.equalTo(1.0)
        }
    }
    
    // add gestures
    func setPanGestureRecognizer() -> UIPanGestureRecognizer {
        
        panRecognizer = UIPanGestureRecognizer (target: self, action: #selector(self.wasDragged(_:)))
        panRecognizer.minimumNumberOfTouches = 1
        panRecognizer.maximumNumberOfTouches = 1
        panRecognizer.cancelsTouchesInView = false
        return panRecognizer
    }
    
    func setTapRecognizer() -> UITapGestureRecognizer {
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.wasTapped(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.cancelsTouchesInView = false
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.require(toFail: panRecognizer)
        return tapRecognizer
    }
    
    func wasTapped(_ gesture: UITapGestureRecognizer) {
        let view = gesture.view!
        
        if gesture.state == .ended {
            
            previousPoint = CGPoint(x: view.frame.midX, y: view.frame.midY)
            
            switch view.accessibilityIdentifier! {
            default:
                propertyAnimator?.addAnimations {
                    view.snp.remakeConstraints({ (make) in
                        make.leading.top.equalToSuperview().offset(8.0)
                        make.size.equalTo(50.0)
                    })
                    self.view.layoutIfNeeded()
                }
                
                propertyAnimator?.addAnimations ({
                    self.toDoView.snp.remakeConstraints({ (make) in
                        make.height.width.equalToSuperview().multipliedBy(0.8)
                        make.center.equalToSuperview()
                    })
                    
                    self.toDoView.layer.opacity = 1.0
                    
                    self.view.layoutIfNeeded()
                    }, delayFactor: 0.5)

                propertyAnimator?.startAnimation()
            }
        }
    }
    
    
    func wasDragged(_ gesture: UIPanGestureRecognizer) {
        let label = gesture.view!
        let translation = gesture.translation(in: self.view)
        
        label.center = CGPoint(x: label.center.x + translation.x , y: label.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: self.view)
        
        //TODO: - MATH -- min > kagami.min && max < kagami.max
        
        if gesture.state == .began {
            dump("Parent View \(self.view.subviews.count)")
            dump("Kagami View \(self.kagamiView.subviews.count)")
        }
        
        if gesture.state == .changed {
            dump("Label Center \(label.center) Translation: \(translation)")
        }
        
        if gesture.state == .ended {
            
            let centerOfLabel = self.kagamiView.convert(label.center, from: label.superview)
            
            if kagamiView.bounds.contains(centerOfLabel) {
                self.kagamiView.addSubview(label)
                label.snp.remakeConstraints({ (make) in
                    make.center.equalTo(centerOfLabel)
                    make.height.width.equalTo(50.0)
                })
                kagamiView.layoutSubviews()
                userDefault.set(["onMirror" : true, "x" : label.frame.midX, "y" : label.frame.midY], forKey: label.accessibilityIdentifier!)
            }
            else {
                self.iconContainerView.addSubview(label)
                label.snp.makeConstraints { (make) in
                    make.bottom.equalToSuperview().offset(-5.0)
                    make.width.height.equalTo(50.0)
                    make.leading.equalToSuperview().offset((label.tag * 50) + (8 * label.tag) + 8)
                }
                userDefault.set(["onMirror" : false, "x" : label.frame.midX, "y" : label.frame.midY], forKey: label.accessibilityIdentifier!)
            }
            
            for subView in kagamiView.subviews {
                switch subView.accessibilityIdentifier! {
                case "weather":
                    let weatherNode = ref.child("weather")
                    //weatherNode.updateChildValues(["x" : (subView.frame.minX / kagamiView.frame.maxX) , "y" : (subView.frame.minY / kagamiView.bounds.maxY), "onMirror" : true])
                    print("This Is \(subView.accessibilityIdentifier!)")
                    print(subView.frame)
                case "time":
                    print("This Is \(subView.accessibilityIdentifier!)")
                    print(subView.frame)
                case "todos":
                    print("This Is \(subView.accessibilityIdentifier!)")
                    print(subView.frame)
                    
                default:
                    break
                }
                
            }
        }
    }
    
    // MARK: - Lazy Instantiates
    lazy var kagamiView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.accentColor
        view.layer.borderColor = ColorPalette.blackColor.cgColor
        view.layer.borderWidth = 1.0
        view.alpha = 0.8
        return view
    }()
    
    lazy var iconContainerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var toDoView: ToDoView = {
        let view = ToDoView()
        view.layer.opacity = 0.0
        view.clipsToBounds = true
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



