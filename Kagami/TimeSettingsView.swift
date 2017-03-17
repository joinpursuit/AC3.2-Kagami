//
//  TimeSettingsView.swift
//  Kagami
//
//  Created by Eric Chang on 3/17/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseDatabase
import TwicketSegmentedControl

class TimeSettingsView: WidgetSettingsView {

    // MARK: - Properties
    var time: Time?
    let dateFormatter = DateFormatter()
    let currentDateTime = Date()
    let date = NSDate()
    let calendar = NSCalendar.current
    let userDefault = UserDefaults.standard
    
    var databaseReference: FIRDatabaseReference!
    //    var user: FIRUser?
    var timeWidget: Time?
    
    override init(widget: Widgetable) {
        super.init(widget: widget)
        
        self.backgroundColor = .clear
        self.alpha = 0.8
        self.layer.cornerRadius = 9
        
        if let time = widget as? Time {
            self.timeWidget = time
        }
        
        databaseReference = FIRDatabase.database().reference()
        
        setDateFormatterStyles()
        
        setupViewHierarchy()
        setupSubviews()
        configureConstraints()
        
        loadUserDefaults()
        setDefaultTimeLabelText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewHierarchy() {        
        self.addSubview(clockAndTimeView)
        self.addSubview(segmentView)
        self.addSubview(clockImageView)
        self.addSubview(timeLabel)
        self.addSubview(headerImage)
        segmentView.addSubview(timeFormatSegmentedControl)
        
        //        doneButton.addTarget(self, action: #selector(setTimeFormat), for: .touchUpInside)
    }
    
    private func setupSubviews() {

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
        
        //Labels
        timeLabel.snp.makeConstraints { (label) in
            label.centerX.equalToSuperview()
            label.top.equalTo(headerImage.snp.bottom).offset(50)
        }
        
        //SegmentedControl
        timeFormatSegmentedControl.snp.makeConstraints { (control) in
            control.top.bottom.equalTo(segmentView)
            control.left.equalTo(segmentView).inset(100)
            control.right.equalTo(segmentView).inset(100)
        }
        
    }
    
    
    
    //MARK: - Methods
    func setTimeFormat() {
        let militaryTimeRef = databaseReference.child("time/militaryTime")
        
        militaryTimeRef.setValue(timeWidget?.militaryTime) {(error, reference) in
            if let error = error {
                print(error)
            }
            else {
                print(reference)
            }
        }
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
    
    //Header
    lazy var headerImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "timeheader")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //TwicketSegmentedControl
    lazy var timeFormatSegmentedControl: TwicketSegmentedControl = {
        let titles = ["12 HR", "24 HR"]
        let segmentedControl = TwicketSegmentedControl()
        segmentedControl.setSegmentItems(titles)
        segmentedControl.delegate = self
        segmentedControl.highlightTextColor = ColorPalette.whiteColor
        segmentedControl.sliderBackgroundColor = ColorPalette.accentColor
        segmentedControl.isSliderShadowHidden = false
        segmentedControl.backgroundColor = .clear
        return segmentedControl
    }()
    
    //Buttons
    //    lazy var doneButton: UIButton = {
    //        let button = UIButton()
    //        let image = UIImage(named: "Ok-50")
    //        button.setImage(image, for: .normal)
    //        return button
    //    }()
    //

}

extension TimeSettingsView: TwicketSegmentedControlDelegate {
    func didSelect(_ segmentIndex: Int) {
        
        switch segmentIndex {
        case 0:
            timeLabel.text = dateFormatter.string(from: currentDateTime)
            timeWidget?.militaryTime = false
            userDefault.setValue(true, forKey: "timeBool")
            
        case 1:
            let hour = calendar.component(.hour, from: date as Date)
            let minutes = calendar.component(.minute, from: date as Date)
            
            guard minutes > 10 else {
                timeLabel.text = ("\(hour):0\(minutes) ")
                break
            }
            timeLabel.text = ("\(hour):\(minutes) ")
            timeWidget?.militaryTime = true
            userDefault.setValue(false, forKey: "timeBool")
        default:
            print("Blah")
        }
    }
    
}
