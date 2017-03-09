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
  let formatter = DateFormatter()
  let currentDateTime = Date()
  let date = NSDate()
  let calendar = NSCalendar.current
  var databaseReference: FIRDatabaseReference!
  var user: FIRUser?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    databaseReference = FIRDatabase.database().reference()
    time = Time(militaryTime: false)
    
    setupViewHierarchy()
    configureConstraints()
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
      view.top.equalTo(self.snp.top).inset(150)
      view.height.equalTo(40)
      view.width.equalTo(370)
    }
    clockAndTimeView.snp.makeConstraints { (view) in
      view.top.trailing.leading.equalToSuperview()
      view.height.equalTo(self.snp.height).multipliedBy(0.5)
    }
    
    //Labels
    timeLabel.snp.makeConstraints { (label) in
      label.centerX.equalTo(clockAndTimeView.snp.centerX)
      label.centerY.equalTo(clockAndTimeView.snp.centerY)
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
      control.left.equalTo(segmentView).inset(120)
      control.right.equalTo(segmentView).inset(120)
    }
    
    //Button
    doneButton.snp.makeConstraints { (view) in
      view.centerX.equalToSuperview()
      view.bottom.equalToSuperview()
    }
  }
  
  // MARK: - UISegmentedControl
  func timeFormatChanged(sender: UISegmentedControl) {
    formatter.timeStyle = .short
    formatter.dateStyle = .none
    
    switch sender.selectedSegmentIndex {
    case 0:
      timeLabel.text = formatter.string(from: currentDateTime)
      time?.militaryTime = false
    case 1:
      let hour = calendar.component(.hour, from: date as Date)
      let minutes = calendar.component(.minute, from: date as Date)
      
      let amOrPm = formatter.string(from: currentDateTime).components(separatedBy: " ")
      timeLabel.text = ("\(hour):\(minutes) ") + amOrPm[1]
      time?.militaryTime = true
    default:
      print("Blah")
    }
  }
  
  //MARK: - Actions
  //KagamiViewController presents SettingsViewController
  //ClockView gets removed from SettingsViewController
  //Firebase gets user preference information
  
  func dismissScreen() {
    let svc = SettingsViewController()
    svc.view.removeFromSuperview()
    svc.dismiss(animated: true, completion: nil)
    
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
  
  //MARK: - Lazy Inits
  //Labels
  lazy var timeLabel: UILabel = {
    let label: UILabel = UILabel()
    label.font = UIFont(name: "DS-Digital", size: 60)
    label.textColor = .white
    return label
  }()
  
  //Views
  lazy var clockAndTimeView: UIView = {
    let view: UIView = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var segmentView: UIView = {
    let view = UIView()
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
    let frame = CGRect(x: 0, y: self.frame.height / 2, width: self.frame.width, height: 40)
    let segmentedControl = TwicketSegmentedControl(frame: frame)
    segmentedControl.setSegmentItems(titles)
    segmentedControl.delegate = self
    segmentedControl.highlightTextColor = ColorPalette.whiteColor
    segmentedControl.sliderBackgroundColor = ColorPalette.accentColor
    segmentedControl.isSliderShadowHidden = false
    return segmentedControl
  }()
  
  //UIButtons
  lazy var doneButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Done", for: .normal)
    button.titleLabel?.font = UIFont(name: "Montserrat-Light", size: 20)
    button.setTitleColor(UIColor.white, for: .normal)
    button.layer.borderWidth = 1.5
    button.layer.cornerRadius = 20
    button.layer.borderColor = UIColor.black.cgColor
    button.backgroundColor = UIColor.clear
    button.addTarget(self, action: #selector(dismissScreen), for: .touchUpInside)
    return button
  }()
}

extension TimeView: TwicketSegmentedControlDelegate {
  func didSelect(_ segmentIndex: Int) {
    print("Selected index at: \(segmentIndex)!")
    if segmentIndex == 0 {
      print("switch to fahrenheight")
    } else {
      print("Switch to celsius")
    }
  }
}

