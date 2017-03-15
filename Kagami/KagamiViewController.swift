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

struct Widget {
    
    var category : Category
    
    init(category: Category) {
        self.category = category
    }
    
    enum Category : Int {
        case weather, forecast, time, todos, quote
        
        var dockIcon : UIImage {
            switch self {
            case .weather: return UIImage(named: "cloud")!
            case .forecast: return UIImage(named: "Flash_Logo_01")!
            case .time: return UIImage(named: "clock")!
            case .todos: return UIImage(named: "checklist")!
            case .quote: return UIImage(named: "quote")!
            }
        }
        
        var mirrorIcon : UIImage {
            switch self {
            case .weather: return UIImage(named: "Flash_Logo_01")!
            case .forecast: return UIImage(named: "Flash_Logo_01")!
            case .time: return UIImage(named: "Flash_Logo_01")!
            case .todos: return UIImage(named: "Flash_Logo_01")!
            case .quote: return UIImage(named: "Flash_Logo_01")!
            }
        }
        
        var description : String {
            switch self {
            case .weather: return "weather"
            case .forecast: return "forecast"
            case .time: return "time"
            case .todos: return "toDos"
            case .quote: return "quote"
            }
        }
    }
    let widgetView = UIView()
    let dockView = UIImageView()
    let mirrorView = UIImageView()
    
}

// should be for dock if dock/mirror are put into own UIView class - separate from KVC
protocol KagamiViewControllerDataSource : class {
    var widgetViews: [WidgetView] { get set }
}

class KagamiViewController: UIViewController {
    
    // MARK: - Properties
    var ref: FIRDatabaseReference!
    let userDefault = UserDefaults.standard
    var propertyAnimator: UIViewPropertyAnimator?
    
    var panRecognizer = UIPanGestureRecognizer()
    var tapRecognizer = UITapGestureRecognizer()
    weak var delegate : KagamiViewControllerDataSource?
    
//    var widgetArray = [Widget(category: .weather), Widget(category: .forecast), Widget(category: .time), Widget(category: .todos), Widget(category: .quote)]
    var previousPoint: CGPoint?
    var widgetBeingEdited: UIView?
    
    var didTapWidget: () -> () = { }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.title = "鏡"
        mirrorAnimationView.play()
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
        view.addSubview(mirrorAnimationView)
        view.addSubview(kagamiView)
        view.addSubview(iconContainerView)
        view.addSubview(weatherView)
        view.addSubview(forecastView)
        view.addSubview(timeView)
        view.addSubview(toDoView)
        view.addSubview(quoteView)
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
        
        guard let widgetViews = self.delegate?.widgetViews else { return }
        
        for widgetView in widgetViews {
            
            widgetView.isUserInteractionEnabled = true
            self.view.addSubview(widgetView)
            
            let widgetDict = userDefault.dictionary(forKey: widgetView.accessibilityIdentifier!)
            
            if widgetDict != nil {
                
                if widgetDict?["onMirror"] as! Bool == true {
                    let x = widgetDict?["x"] as! CGFloat
                    let y = widgetDict?["y"] as! CGFloat
                    widgetView.subviews[0].alpha = 0.0
                    widgetView.subviews[1].alpha = 1.0
                    widgetView.snp.makeConstraints({ (make) in
                        make.center.equalTo(CGPoint(x: x, y: y))
                        make.height.width.equalTo(50.0)
                    })
                }
                else {
                    if widgetDict?["onMirror"] as! Bool == false {
                        widgetView.snp.makeConstraints({ (make) in
                            make.bottom.equalTo(iconContainerView.snp.bottom).offset(-5.0)
                            make.width.height.equalTo(50.0)
                            make.leading.equalTo(iconContainerView.snp.leading).offset((widgetView.tag * 50) + (8 * widgetView.tag) + 8)
                        })
                        
                    }
                }
            }
            else {
                widgetView.snp.makeConstraints { (make) in
                    make.bottom.equalTo(iconContainerView.snp.bottom).offset(-5.0)
                    make.width.height.equalTo(50.0)
                    make.leading.equalTo(iconContainerView.snp.leading).offset((widgetView.tag * 50) + (8 * widgetView.tag) + 8)
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
    
    func saveForecast(_ sender: UIButton) {
        guard let view = widgetBeingEdited else { return }
        
        if sender == forecastView.doneButton {
            print("forecast done works")
        }
        propertyAnimator?.addAnimations {
            
            self.forecastView.snp.remakeConstraints({ (make) in
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



