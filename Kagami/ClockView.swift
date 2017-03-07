//
//  ClockView.swift
//  Kagami
//
//  Created by Eashir Arafat on 3/6/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ClockView: UIView {
  var clock: Clock?
  let formatter = DateFormatter()
  let currentDateTime = Date()
  let date = NSDate()
  let calendar = NSCalendar.current
  var databaseReference: FIRDatabaseReference!
  var user: FIRUser?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // add subviews
    self.addSubview(clockAndTimeView)
    self.addSubview(clockImageView)
    self.addSubview(timeLabel)
    self.addSubview(timeFormatSegmentedControl)
    
    // configure constraints
    clockAndTimeView.snp.makeConstraints { (view) in
      view.top.trailing.leading.equalToSuperview()
      view.height.equalTo(self.snp.height).multipliedBy(0.5)
    }
    
    timeLabel.snp.makeConstraints { (label) in
      label.centerX.equalTo(clockAndTimeView.snp.centerX)
      label.centerY.equalTo(clockAndTimeView.snp.centerY)
    }
    
    clockImageView.snp.makeConstraints { (view) in
      view.height.equalTo(clockAndTimeView.snp.height).multipliedBy(0.8)
      view.width.equalTo(clockAndTimeView.snp.width).multipliedBy(0.8)
      view.centerX.equalTo(clockAndTimeView.snp.centerX)
      view.centerY.equalTo(clockAndTimeView.snp.centerY)
    }
    
    timeFormatSegmentedControl.snp.makeConstraints { (view) in
      view.top.equalTo(clockAndTimeView.snp.bottom)
      view.centerX.equalTo(clockAndTimeView.snp.centerX)
      view.height.equalTo(50)
      view.width.equalTo(100)
    }
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
  // MARK: - UISegmentedControl
  func timeFormatChanged(sender: UISegmentedControl) {
    formatter.timeStyle = .short
    formatter.dateStyle = .none
    
    switch sender.selectedSegmentIndex {
    case 0:
      timeLabel.text = formatter.string(from: currentDateTime)
      clock?.militaryTime = false
      clock?.timeZone = TimeZone.current.abbreviation()!
    case 1:
      let hour = calendar.component(.hour, from: date as Date)
      let minutes = calendar.component(.minute, from: date as Date)
      
      let amOrPm = formatter.string(from: currentDateTime).components(separatedBy: " ")
      timeLabel.text = ("\(hour):\(minutes) ") + amOrPm[1]
      clock?.militaryTime = true
      clock?.timeZone = TimeZone.current.abbreviation()!
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
    militaryTimeRef.setValue(clock?.militaryTime)
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
  
  //ImageViews
  lazy var clockImageView: UIImageView = {
    let imageView: UIImageView = UIImageView()
//    imageView.image = #imageLiteral(resourceName: "Clock")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  //UISegmentedControl
  lazy var timeFormatSegmentedControl: UISegmentedControl = {
    let segmentedControl: UISegmentedControl = UISegmentedControl(items: ["12 HR" , "24 HR"])
    segmentedControl.layer.cornerRadius = 5.0  // Don't let background bleed
    segmentedControl.backgroundColor = .black
    segmentedControl.tintColor = .red
    segmentedControl.addTarget(self, action: #selector(timeFormatChanged(sender:)), for: .valueChanged)
    segmentedControl.selectedSegmentIndex = 0
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
