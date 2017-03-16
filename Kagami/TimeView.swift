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

class TimeView: UIView {
    
    var time: Time?
    let dateFormatter = DateFormatter()
    let currentDateTime = Date()
    let date = NSDate()
    let calendar = NSCalendar.current
    let userDefault = UserDefaults.standard
    var gradientLayer: CAGradientLayer!
    
    var databaseReference: FIRDatabaseReference!
    var user: FIRUser?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createGradientLayer()
        self.layer.cornerRadius = 9
        
        databaseReference = FIRDatabase.database().reference()
        time = Time(militaryTime: false)
        
        setDateFormatterStyles()
        
        setupViewHierarchy()
        configureConstraints()
        
        loadUserDefaults()
        setDefaultTimeLabelText()
        
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("WOOO \(key) = \(value) \n")
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 650))
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red:0.56, green:0.62, blue:0.67, alpha:1.0).cgColor, UIColor(red:0.93, green:0.95, blue:0.95, alpha:1.0).cgColor]
        gradientLayer.locations = [0.0 , 1.0]
        self.layer.addSublayer(gradientLayer)
    }
    
    // MARK: Setup
    func setupViewHierarchy () {
        self.addSubview(clockAndTimeView)
        self.addSubview(segmentView)
        self.addSubview(clockImageView)
        self.addSubview(timeLabel)
        self.addSubview(doneButton)
        self.addSubview(cancelButton)
        self.addSubview(headerImage)
        segmentView.addSubview(timeFormatSegmentedControl)
        doneButton.addTarget(self, action: #selector(setTimeFormat), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }
    
    func configureConstraints() {
        //Views
        headerImage.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalTo(self.snp.top).inset(50)
        }
        segmentView.snp.makeConstraints { (view) in
            view.left.right.equalToSuperview()
            view.top.equalTo(timeLabel.snp.bottom).offset(40)
            view.height.equalTo(40)
        }
        //    clockAndTimeView.snp.makeConstraints { (view) in
        //      view.top.trailing.leading.equalToSuperview()
        //      view.height.equalTo(self.snp.height).multipliedBy(0.5)
        //    }
        //
        //Labels
        timeLabel.snp.makeConstraints { (label) in
            label.centerX.equalToSuperview()
            label.top.equalTo(headerImage.snp.bottom).offset(50)
        }
        
        //ImageViews
        //    clockImageView.snp.makeConstraints { (view) in
        //      view.height.equalTo(clockAndTimeView.snp.height).multipliedBy(0.8)
        //      view.width.equalTo(clockAndTimeView.snp.width).multipliedBy(0.8)
        //      view.centerX.equalTo(clockAndTimeView.snp.centerX)
        //      view.centerY.equalTo(clockAndTimeView.snp.centerY)
        //    }
        
        //SegmentedControl
        timeFormatSegmentedControl.snp.makeConstraints { (control) in
            control.top.bottom.equalTo(segmentView)
            control.left.equalTo(segmentView).inset(100)
            control.right.equalTo(segmentView).inset(100)
        }
        
        //Button
        doneButton.snp.makeConstraints { (view) in
            view.right.equalTo(self.snp.right).inset(8)
            view.bottom.equalTo(self.snp.bottom).inset(8)
        }
        
        cancelButton.snp.makeConstraints { (view) in
            view.left.equalTo(self.snp.left).inset(8)
            view.bottom.equalTo(self.snp.bottom).inset(8)
        }
    }
    
    //MARK: - Methods
    func setTimeFormat() {
        let militaryTimeRef = databaseReference.child("time/militaryTime")
        
        militaryTimeRef.setValue(time?.militaryTime) {(error, reference) in
            if let error = error {
                print(error)
            }
            else {
                print(reference)
            }
        }
    }
    
    func cancelTapped() {
        print("cancel tapped")
    }
    
    func loadUserDefaults() {
        if userDefault.object(forKey: "timeBool") != nil {
            let is12Hr = userDefault.object(forKey: "timeBool") as! Bool
            if is12Hr {
                timeFormatSegmentedControl.move(to: 0)
            } else {
                timeFormatSegmentedControl.move(to: 1)
            }
        }
    }
    
    func setDateFormatterStyles() {
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
    }
    
    func setDefaultTimeLabelText() {
        
        switch timeFormatSegmentedControl.selectedSegmentIndex {
        case 0:
            timeLabel.text = dateFormatter.string(from: currentDateTime)
            
        case 1:
            let hour = calendar.component(.hour, from: date as Date)
            let minutes = calendar.component(.minute, from: date as Date)
            
            guard minutes > 9 else {
                timeLabel.text = ("\(hour):0\(minutes) ")
                break
            }
            timeLabel.text = ("\(hour):\(minutes) ")
            
        default:
            print("Blah")
        }
    }
    
    //MARK: - Lazy Inits
    //Labels
    lazy var timeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont(name: "Code-Pro-Demo", size: 72)
        label.textColor = ColorPalette.whiteColor
        return label
    }()
    
    //Views
    lazy var clockAndTimeView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    lazy var segmentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    //ImageViews
    lazy var clockImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        //    imageView.image = #imageLiteral(resourceName: "Clock")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //TwicketSegmentedControl
    lazy var timeFormatSegmentedControl: TwicketSegmentedControl = {
        let segmentedControl = TwicketSegmentedControl()
        let titles = ["12HR", "24HR"]
        segmentedControl.setSegmentItems(titles)
        segmentedControl.delegate = self
        segmentedControl.highlightTextColor = ColorPalette.accentColor
        segmentedControl.sliderBackgroundColor = ColorPalette.whiteColor
        segmentedControl.segmentsBackgroundColor = ColorPalette.grayColor
        segmentedControl.isSliderShadowHidden = false
        segmentedControl.backgroundColor = .clear
        return segmentedControl
    }()
    
    //Buttons
    lazy var doneButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Ok-50")
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Cancel-50")
        button.setImage(image, for: .normal)
        return button
    }()
    
    //Header
    lazy var headerImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "timeheader")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
}

extension TimeView: TwicketSegmentedControlDelegate {
    func didSelect(_ segmentIndex: Int) {
        
        switch segmentIndex {
        case 0:
            timeLabel.text = dateFormatter.string(from: currentDateTime)
            time?.militaryTime = false
            userDefault.setValue(true, forKey: "timeBool")
            
        case 1:
            let hour = calendar.component(.hour, from: date as Date)
            let minutes = calendar.component(.minute, from: date as Date)
            
            guard minutes > 10 else {
                timeLabel.text = ("\(hour):0\(minutes) ")
                break
            }
            timeLabel.text = ("\(hour):\(minutes) ")
            time?.militaryTime = true
            userDefault.setValue(false, forKey: "timeBool")
        default:
            print("Blah")
        }
    }
}

