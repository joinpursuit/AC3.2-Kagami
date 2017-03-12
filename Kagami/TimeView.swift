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
  
  var databaseReference: FIRDatabaseReference!
  var user: FIRUser?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.alpha = 0.8
    self.layer.cornerRadius = 9
    
    databaseReference = FIRDatabase.database().reference()
    time = Time(militaryTime: false)
    
    setDateFormatterStyles()
    
    setupViewHierarchy()
    configureConstraints()
    
    loadUserDefaults()
    setDefaultTimeLabelText()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
  // MARK: Setup
  func setupViewHierarchy () {
    self.addSubview(clockAndTimeView)
    self.addSubview(segmentView)
    self.addSubview(clockImageView)
    self.addSubview(timeLabel)
    self.addSubview(doneButton)
    segmentView.addSubview(timeFormatSegmentedControl)
  }
  
  func configureConstraints() {
    //Views
    segmentView.snp.makeConstraints { (view) in
      view.left.right.equalToSuperview()
      view.top.equalTo(self.snp.top).inset(250)
      view.height.equalTo(40)
    }
    clockAndTimeView.snp.makeConstraints { (view) in
      view.top.trailing.leading.equalToSuperview()
      view.height.equalTo(self.snp.height).multipliedBy(0.5)
    }
    
    //Labels
    timeLabel.snp.makeConstraints { (label) in
      label.centerX.equalTo(clockAndTimeView.snp.centerX)
      label.bottom.equalTo(segmentView.snp.top).offset(-70.0)
    }
    
    //ImageViews
    clockImageView.snp.makeConstraints { (view) in
      view.height.equalTo(clockAndTimeView.snp.height).multipliedBy(0.8)
      view.width.equalTo(clockAndTimeView.snp.width).multipliedBy(0.8)
      view.centerX.equalTo(clockAndTimeView.snp.centerX)
      view.centerY.equalTo(clockAndTimeView.snp.centerY)
    }
    
    //SegmentedControl
    timeFormatSegmentedControl.snp.makeConstraints { (control) in
      control.top.bottom.equalTo(segmentView)
      control.left.equalTo(segmentView).inset(100)
      control.right.equalTo(segmentView).inset(100)
    }
    
    //Button
    doneButton.snp.makeConstraints { (button) in
      button.centerX.equalToSuperview()
      button.bottom.equalToSuperview().inset(100.0)
      button.width.equalToSuperview().multipliedBy(0.15)
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
  
  func loadUserDefaults() {
    if userDefault.object(forKey: "time") != nil {
      let is12Hr = userDefault.object(forKey: "time") as! Bool
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
    label.font = UIFont(name: "Code-Pro-Light-Demo", size: 72)
    label.textColor = UIColor(red:0.76, green:0.83, blue:0.90, alpha:1.0)

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
  lazy var doneButton: UIButton = {
    let button = UIButton()
    let image = UIImage(named: "Add Filled-50")
    button.setImage(image, for: .normal)
    button.addTarget(self, action: #selector(setTimeFormat), for: .touchUpInside)
    return button
  }()
}

extension TimeView: TwicketSegmentedControlDelegate {
  func didSelect(_ segmentIndex: Int) {
      
      switch segmentIndex {
      case 0:
        timeLabel.text = dateFormatter.string(from: currentDateTime)
        time?.militaryTime = false
        userDefault.setValue(true, forKey: "time")
        
      case 1:
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        
       guard minutes > 10 else {
          timeLabel.text = ("\(hour):0\(minutes) ")
          break
        }
        timeLabel.text = ("\(hour):\(minutes) ")
        time?.militaryTime = true
        userDefault.setValue(false, forKey: "time")
      default:
        print("Blah")
      }
  }
}

