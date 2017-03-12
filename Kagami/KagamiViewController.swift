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
        case weather, time, todos, quote
        
        var icon : UIImage {
            switch self {
            case .weather: return UIImage(named: "cloud-icon")!
            case .time: return UIImage(named: "clock-icon")!
            case .todos: return UIImage(named: "checklist-icon")!
            case .quote: return UIImage(named: "quote")!
            }
        }
        
        var description : String {
            switch self {
            case .weather: return "weather"
            case .time: return "time"
            case .todos: return "toDos"
            case .quote: return "quote"
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
    
    var widgetArray = [Widget(category: .weather), Widget(category: .time), Widget(category: .todos), Widget(category: .quote)]
    var previousPoint: CGPoint?
    var widgetBeingEdited: UIImageView?
    
    var didTapWidget: () -> () = { }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "鏡"
        propertyAnimator = UIViewPropertyAnimator(duration: 0.75, dampingRatio: 0.77, animations: nil)
        
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
        
        view.addSubview(mirrorImageView)
        view.addSubview(kagamiView)
        view.addSubview(iconContainerView)
        view.addSubview(weatherView)
        view.addSubview(timeView)
        view.addSubview(toDoView)
        view.addSubview(quoteView)
        
        weatherView.doneButton.addTarget(self, action: #selector(saveWeather), for: .touchDown)
        weatherView.cancelButton.addTarget(self, action: #selector(saveWeather), for: .touchDown)
        
        timeView.doneButton.addTarget(self, action: #selector(saveTime), for: .touchUpInside)
        
        toDoView.doneButton.addTarget(self, action: #selector(saveToDo), for: .touchUpInside)
        toDoView.cancelButton.addTarget(self, action: #selector(saveToDo), for: .touchUpInside)
        
        quoteView.doneButton.addTarget(self, action: #selector(saveQuote), for: .touchUpInside)
        quoteView.cancelButton.addTarget(self, action: #selector(saveQuote), for: .touchUpInside)
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
                }
                else {
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
        
        weatherView.snp.makeConstraints { (make) in
            make.center.equalTo(widgetArray[0].imageView)
            make.size.equalTo(30.0)
        }
        
        timeView.snp.makeConstraints { (make) in
            make.center.equalTo(widgetArray[1].imageView)
            make.size.equalTo(0.1)
        }
        
        toDoView.snp.makeConstraints { (make) in
            make.center.equalTo(widgetArray[2].imageView)
            make.size.equalTo(0.1)
        }
        
        quoteView.snp.makeConstraints { (make) in
            make.center.equalTo(widgetArray[3].imageView)
            make.size.equalTo(0.1)
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
            case "weather":
                propertyAnimator?.addAnimations ({
                    self.weatherView.snp.remakeConstraints({ (make) in
                        make.height.width.equalToSuperview().multipliedBy(0.8)
                        make.center.equalToSuperview()
                    })
                    
                    self.kagamiView.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
                    self.weatherView.layer.opacity = 1.0
                    
                    self.view.layoutIfNeeded()
                })

                widgetBeingEdited = widgetArray[0].imageView
            case "time":
                propertyAnimator?.addAnimations ({
                    self.timeView.snp.remakeConstraints({ (make) in
                        make.height.width.equalToSuperview().multipliedBy(0.8)
                        make.center.equalToSuperview()
                    })
                    
                    self.kagamiView.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
                    self.timeView.layer.opacity = 1.0
                    
                    self.view.layoutIfNeeded()
                })
                
                widgetBeingEdited = widgetArray[1].imageView
            case "toDos":
                propertyAnimator?.addAnimations ({
                    self.toDoView.snp.remakeConstraints({ (make) in
                        make.height.width.equalToSuperview().multipliedBy(0.7)
                        make.center.equalToSuperview()
                    })
                    
                    self.kagamiView.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
                    self.toDoView.layer.opacity = 1.0
                    
                    self.view.layoutIfNeeded()
                })

                widgetBeingEdited = widgetArray[2].imageView
            case "quote":
                propertyAnimator?.addAnimations ({
                    self.quoteView.snp.remakeConstraints({ (make) in
                        make.height.width.equalToSuperview().multipliedBy(0.8)
                        make.center.equalToSuperview()
                    })
                    
                    self.kagamiView.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
                    self.quoteView.layer.opacity = 1.0
                    
                    self.view.layoutIfNeeded()
                })
                
                widgetBeingEdited = widgetArray[3].imageView
            default:
                break
            }
            propertyAnimator?.startAnimation()
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
                ref.child(label.accessibilityIdentifier!).updateChildValues(["onMirror" : false])
            }
            
            for subView in kagamiView.subviews {
                switch subView.accessibilityIdentifier! {
                case "weather":
                    let weatherNode = ref.child("weather")
                    weatherNode.updateChildValues(["x" : (subView.frame.minX / kagamiView.frame.maxX) , "y" : (subView.frame.minY / kagamiView.bounds.maxY), "onMirror" : true])
                    print("This Is \(subView.accessibilityIdentifier!)")
                    print(subView.frame)
                case "time":
                    let timeNode = ref.child("time")
                    timeNode.updateChildValues(["x" : (subView.frame.minX / kagamiView.frame.maxX) , "y" : (subView.frame.minY / kagamiView.bounds.maxY), "onMirror" : true])
                    print("This Is \(subView.accessibilityIdentifier!)")
                    print(subView.frame)
                case "toDos":

                    let toDoNode = ref.child("toDos")
                    toDoNode.updateChildValues(["x" : (subView.frame.minX / kagamiView.frame.maxX) , "y" : (subView.frame.minY / kagamiView.bounds.maxY), "onMirror" : true])
                    print("This Is \(subView.accessibilityIdentifier!)")
                    print(subView.frame)
                case "quote":
                    let toDoNode = ref.child("quote")
                    toDoNode.updateChildValues(["x" : (subView.frame.minX / kagamiView.frame.maxX) , "y" : (subView.frame.minY / kagamiView.bounds.maxY), "onMirror" : true])
                    print("This Is \(subView.accessibilityIdentifier!)")
                    print(subView.frame)
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - Save custom settings
    //TODO: - Migrate to seperate file
    func saveWeather(_ sender: UIButton) {
        guard let view = widgetBeingEdited else { return }
        
        if sender == weatherView.doneButton {
            // save to firebase
            print("weather done works")
        }
        
        propertyAnimator?.addAnimations {
            
            self.weatherView.snp.remakeConstraints({ (make) in
                make.size.equalTo(0.1)
                make.center.equalTo(view.snp.center)
            })
            
            self.view.layoutIfNeeded()
        }

        self.kagamiView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        propertyAnimator?.startAnimation()
    }
    
    func saveTime(_ sender: UIButton) {
        guard let view = widgetBeingEdited else { return }
        
        if sender == timeView.doneButton {
            // save to firebase
            print("time done works")
        }
        
        propertyAnimator?.addAnimations {
            
            self.timeView.snp.remakeConstraints({ (make) in
                make.size.equalTo(0.1)
                make.center.equalTo(view.snp.center)
            })
            
            self.view.layoutIfNeeded()
        }
        //TODO: backgroundColor inside animations will flash black screen for 0.5 seconds
        self.kagamiView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        propertyAnimator?.startAnimation()
    }
    
    func saveToDo(_ sender: UIButton) {
        guard let view = widgetBeingEdited else { return }
        
        if sender == toDoView.doneButton {
            // save to firebase
            print("todo done works")
        }
        
        propertyAnimator?.addAnimations {

            self.toDoView.snp.remakeConstraints({ (make) in
                make.size.equalTo(0.1)
                make.center.equalTo(view.snp.center)
            })
            
            self.view.layoutIfNeeded()
        }
        self.kagamiView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        propertyAnimator?.startAnimation()
    }
    func saveQuote(_ sender: UIButton) {
        guard let view = widgetBeingEdited else { return }
        
        if sender == quoteView.doneButton {
            print("quote done buttonworks")
        }
        
        propertyAnimator?.addAnimations {
            
            self.quoteView.snp.remakeConstraints({ (make) in
                make.size.equalTo(0.1)
                make.center.equalTo(view.snp.center)
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
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2.0
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
        view.backgroundColor = ColorPalette.whiteColor.withAlphaComponent(5)
        return view
    }()
    
    lazy var weatherView: WeatherView = {
        let view = WeatherView()
        view.layer.opacity = 0.0
        view.clipsToBounds = true
        return view
    }()
    
    lazy var timeView: TimeView = {
        let view = TimeView()
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



