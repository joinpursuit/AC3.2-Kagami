//
//  ReminderAndGoalsViewController.swift
//  Kagami
//
//  Created by Annie Tung on 3/1/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import SnapKit

class ReminderAndGoalsViewController: UIViewController {
    
    static let identifier = "ReminderAndGoals"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = ColorPalette.accentColor
        self.view.backgroundColor = .white
        setupViewHierarchy()
        setupConstraints()
    }
    
    // MARK: - Setup View Hierarchy & Constraints
    
    func setupViewHierarchy() {
        self.view.addSubview(blueView)
        self.view.addSubview(goalsView)
        self.view.addSubview(remindersView)
        self.view.addSubview(circleAddImage)
        self.blueView.addSubview(segmentControl)
    }
    
    // MARK: - Methods
    
    func setupConstraints() {
        blueView.snp.makeConstraints { (view) in
            view.top.left.right.equalToSuperview()
            view.height.equalTo(self.view).multipliedBy(0.25)
        }
        goalsView.snp.makeConstraints { (view) in
            view.bottom.left.right.equalToSuperview()
            view.top.equalTo(segmentControl.snp.bottom)
        }
        remindersView.snp.makeConstraints { (view) in
            view.bottom.left.right.equalToSuperview()
            view.top.equalTo(segmentControl.snp.bottom)
        }
        segmentControl.snp.makeConstraints { (control) in
            control.left.right.equalToSuperview()
            control.bottom.equalTo(self.blueView.snp.bottom)//.inset(10)
        }
        circleAddImage.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.bottom.equalTo(self.view.snp.bottom).inset(20)
        }
    }
    
    func switchBetweenView(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UIView.animate(withDuration: 0.2, animations: {
                self.goalsView.alpha = 1
                print("goal")
                self.remindersView.alpha = 0
            })
        case 1:
            UIView.animate(withDuration: 0.2, animations: {
                self.goalsView.alpha = 0
                self.remindersView.alpha = 1
                print("reminder")
            })
        default:
            print("Error")
            break
        }
    }
    
    func addingToFirebase() {
        print("This works")
    }
    
    // MARK: - Lazy Instances
    
    lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.setTitleTextAttributes([NSForegroundColorAttributeName: ColorPalette.grayColor, NSFontAttributeName:UIFont.systemFont(ofSize: 30)], for: UIControlState.normal)
        segmentControl.setTitleTextAttributes([NSForegroundColorAttributeName: ColorPalette.whiteColor, NSFontAttributeName:UIFont.systemFont(ofSize: 30)], for: UIControlState.selected)
        segmentControl.insertSegment(withTitle: "GOAL", at: 0, animated: false)
        segmentControl.insertSegment(withTitle: "REMINDER", at: 1, animated: false)
        segmentControl.backgroundColor = ColorPalette.accentColor
        segmentControl.tintColor = ColorPalette.accentColor
        segmentControl.selectedSegmentIndex = 1
        segmentControl.addTarget(self, action: #selector(switchBetweenView(sender:)), for: UIControlEvents.valueChanged)
        return segmentControl
    }()
    
    lazy var goalsView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var remindersView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var blueView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.accentColor
        return view
    }()
    
    lazy var circleAddImage: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(addingToFirebase), for: .touchUpInside)
        let image = UIImage(named: "Add Filled-50")
        view.setImage(image, for: .normal)
        return view
    }()
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
