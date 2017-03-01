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

        setupSegmentControl()
        self.view.backgroundColor = .white
    }
    
    func setupSegmentControl() {
        self.view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints { (control) in
            control.left.right.equalToSuperview()
            control.top.equalTo(view.snp.top).inset(70)
        }
    }
    
    lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.backgroundColor = .gray
        segmentControl.tintColor = .white
        segmentControl.insertSegment(withTitle: "Goal", at: 0, animated: false)
        segmentControl.insertSegment(withTitle: "Reminder", at: 0, animated: false)
        return segmentControl
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
