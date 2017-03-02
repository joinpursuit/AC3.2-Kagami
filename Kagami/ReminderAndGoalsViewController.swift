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
        setupSegmentControl()
        setupViews()
        self.view.backgroundColor = .white
    }
    
    func setupSegmentControl() {
        self.view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints { (control) in
            control.left.right.equalToSuperview()
            control.top.equalTo(self.view.snp.top).inset(65)
        }
    }
    
    func setupViews() {
        self.view.addSubview(goalsView)
        self.view.addSubview(remindersView)
        goalsView.snp.makeConstraints { (view) in
            view.bottom.left.right.equalToSuperview()
            view.top.equalTo(segmentControl.snp.bottom)
        }
        remindersView.snp.makeConstraints { (view) in
            view.bottom.left.right.equalToSuperview()
            view.top.equalTo(segmentControl.snp.bottom)
        }
    }
    
    func switchBetweenView(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UIView.animate(withDuration: 0.2, animations: {
                self.goalsView.alpha = 1
                self.remindersView.alpha = 0
            })
        case 1:
            UIView.animate(withDuration: 0.2, animations: {
                self.goalsView.alpha = 0
                self.remindersView.alpha = 1
            })
        default:
            print("Error")
            break
        }
    }
    
    lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        let attribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 30)]
        segmentControl.setTitleTextAttributes(attribute, for: .normal)
        segmentControl.insertSegment(withTitle: "GOAL", at: 0, animated: false)
        segmentControl.insertSegment(withTitle: "REMINDER", at: 1, animated: false)
        segmentControl.backgroundColor = ColorPalette.grayColor
        segmentControl.tintColor = .white
        segmentControl.selectedSegmentIndex = 1
        segmentControl.addTarget(self, action: #selector(switchBetweenView(sender:)), for: UIControlEvents.valueChanged)
        return segmentControl
    }()
    
    lazy var goalsView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    lazy var remindersView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
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
