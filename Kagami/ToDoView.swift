//
//  ToDoView.swift
//  Kagami
//
//  Created by Annie Tung on 3/7/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import FirebaseDatabase

class ToDoView: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var database: FIRDatabaseReference!
    var activeTextField: UITextField?
    let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: nil)
    let userDefault = UserDefaults.standard
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.database = FIRDatabase.database().reference().child("toDos").child("lastest")
        textFieldOne.delegate = self
        textFieldTwo.delegate = self
        textFieldThree.delegate = self
        setupView()
        setupConstraints()
        loadUserDefaults()
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up Hierarchy & constraints
    
    func setupView() {
        self.addSubview(doneButton)
        self.addSubview(backgroundView)
        self.addSubview(textFieldOne)
        self.addSubview(textFieldTwo)
        self.addSubview(textFieldThree)
        
        textFieldOne.addSubview(checkBoxOne)
        textFieldTwo.addSubview(checkBoxTwo)
        textFieldThree.addSubview(checkBoxThree)
    }
    
    func setupConstraints() {
        doneButton.snp.makeConstraints { (view) in
            view.left.right.bottom.equalToSuperview()
        }
        backgroundView.snp.makeConstraints { (view) in
            view.top.bottom.left.right.equalToSuperview()
        }
        
        // textfields
        textFieldOne.snp.makeConstraints { (field) in
            field.top.equalTo(self.snp.top).inset(100)
            field.centerX.equalToSuperview()
            field.height.equalTo(self.snp.height).multipliedBy(0.08)
            field.width.equalTo(self.snp.width).multipliedBy(0.9)
        }
        textFieldTwo.snp.makeConstraints { (field) in
            field.top.equalTo(textFieldOne.snp.bottom).offset(25)
            field.centerX.equalToSuperview()
            field.height.equalTo(self.snp.height).multipliedBy(0.08)
            field.width.equalTo(self.snp.width).multipliedBy(0.9)
        }
        textFieldThree.snp.makeConstraints { (field) in
            field.top.equalTo(textFieldTwo.snp.bottom).offset(25)
            field.centerX.equalToSuperview()
            field.height.equalTo(self.snp.height).multipliedBy(0.08)
            field.width.equalTo(self.snp.width).multipliedBy(0.9)
        }
        
        // checkboxes
        checkBoxOne.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(8)
            make.top.equalTo(textFieldOne.snp.top).inset(5)
            make.bottom.equalTo(textFieldOne.snp.bottom).inset(5)
            make.size.equalTo(35)
        }
        checkBoxTwo.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(8)
            make.top.equalTo(textFieldTwo.snp.top).inset(5)
            make.bottom.equalTo(textFieldTwo.snp.bottom).inset(5)
            make.size.equalTo(35)
        }
        checkBoxThree.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(8)
            make.top.equalTo(textFieldThree.snp.top).inset(5)
            make.bottom.equalTo(textFieldThree.snp.bottom).inset(5)
            make.size.equalTo(35)
        }
    }
    
    // MARK: - Methods
    
    func addToMirror() {
        print("add to mirror")
    }
    
    func checkOffItemOne() {
        let itemOneDatabaseRef = self.database.child("1")
        if !checkBoxOne.subviews.contains(checkMarkOne) {
            
            addCheckMarkOne()
            
            let item = ToDo(title: textFieldOne.text!, completed: true)
            let itemDict = item.asDictionary
            itemOneDatabaseRef.setValue(itemDict)
            userDefault.setValue(true, forKey: "item one completed")
            //            animateCheckMark()
        } else {
            checkMarkOne.snp.removeConstraints()
            for view in checkBoxOne.subviews {
                view.removeFromSuperview()
            }
            // remove from firebase
            let item = ToDo(title: textFieldOne.text!, completed: false)
            let itemDict = item.asDictionary
            itemOneDatabaseRef.setValue(itemDict)
            userDefault.setValue(false, forKey: "item one completed")
        }
    }
    
    func checkOffItemTwo() {
        let itemTwoDatabaseRef = self.database.child("2")
        if !checkBoxTwo.subviews.contains(checkMarkTwo) {
            
            addCheckMarkTwo()
            
            let item = ToDo(title: textFieldTwo.text!, completed: true)
            let itemDict = item.asDictionary
            itemTwoDatabaseRef.setValue(itemDict)
            userDefault.setValue(true, forKey: "item two completed")
        } else {
            checkMarkTwo.snp.removeConstraints()
            for view in checkBoxTwo.subviews {
                view.removeFromSuperview()
            }
            let item = ToDo(title: textFieldTwo.text!, completed: false)
            let itemDict = item.asDictionary
            itemTwoDatabaseRef.setValue(itemDict)
            userDefault.setValue(false, forKey: "item two completed")
        }
    }
    
    func checkOffItemThree() {
        let itemThreeDatabaseRef = self.database.child("3")
        if !checkBoxThree.subviews.contains(checkMarkThree) {
            
            addCheckMarkThree()
            
            let item = ToDo(title: textFieldThree.text!, completed: true)
            let itemDict = item.asDictionary
            itemThreeDatabaseRef.setValue(itemDict)
            userDefault.setValue(true, forKey: "item three completed")
        } else {
            checkMarkThree.snp.removeConstraints()
            for view in checkBoxThree.subviews {
                view.removeFromSuperview()
            }
            let item = ToDo(title: textFieldThree.text!, completed: false)
            let itemDict = item.asDictionary
            itemThreeDatabaseRef.setValue(itemDict)
            userDefault.setValue(false, forKey: "item three completed")
        }
    }
    
    //    func animateCheckMark() {
    //        checkMark.snp.makeConstraints { (view) in
    //            view.centerX.centerY.equalTo(checkBoxOne)
    //        }
    //        animator.addAnimations{
    //            self.checkMark.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    //        }
    //        animator.addAnimations {
    //            self.layoutIfNeeded()
    //        }
    //        animator.startAnimation()
    //    }
    
    func loadUserDefaults() {
        
        if userDefault.object(forKey: "item one completed") != nil {
            textFieldOne.text = userDefault.object(forKey: "item one") as? String
            print(textFieldOne.text!)
            print(userDefault.object(forKey: "item one completed") as! Bool)
            let completedFirstItem = userDefault.object(forKey: "item one completed") as! Bool
            if completedFirstItem {
                addCheckMarkOne()
            }
        }
        
        if userDefault.object(forKey: "item two completed") != nil {
            textFieldTwo.text = userDefault.object(forKey: "item two") as? String
            print(textFieldTwo.text!)
            print(userDefault.object(forKey: "item two completed") as! Bool)
            let completedSecondItem = userDefault.object(forKey: "item two completed") as! Bool
            if completedSecondItem {
                addCheckMarkTwo()
            }
        }
        
        if userDefault.object(forKey: "item three completed") != nil {
            textFieldThree.text = userDefault.object(forKey: "item three") as? String
            print(textFieldThree.text!)
            print(userDefault.object(forKey: "item three completed") as! Bool)
            let completedThirdItem = userDefault.object(forKey: "item three completed") as! Bool
            if completedThirdItem {
                addCheckMarkThree()
            }
        }
    }
    
    func addCheckMarkOne() {
        checkBoxOne.addSubview(checkMarkOne)
        checkMarkOne.snp.makeConstraints { (view) in
            view.centerX.centerY.equalTo(checkBoxOne)
        }
    }
    
    func addCheckMarkTwo() {
        checkBoxTwo.addSubview(checkMarkTwo)
        checkMarkTwo.snp.makeConstraints { (view) in
            view.centerX.centerY.equalTo(checkBoxTwo)
        }
    }
    
    func addCheckMarkThree() {
        checkBoxThree.addSubview(checkMarkThree)
        checkMarkThree.snp.makeConstraints { (view) in
            view.centerX.centerY.equalTo(checkBoxThree)
        }
    }
    
    // MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        print("did begin editing")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
        print("did end editing")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("should return")
        guard activeTextField == textField, activeTextField?.text != "" else { return false }
        
        switch activeTextField!.tag {
        case 1:
            let item = ToDo(title: activeTextField!.text!, completed: false)
            let itemDict = item.asDictionary
            let itemOneDatabaseRef = self.database.child("1")
            itemOneDatabaseRef.setValue(itemDict)
            
            userDefault.setValue(activeTextField!.text, forKey: "item one")
        case 2:
            let item = ToDo(title: activeTextField!.text!, completed: false)
            let itemDict = item.asDictionary
            let itemOneDatabaseRef = self.database.child("2")
            itemOneDatabaseRef.setValue(itemDict)
            
            userDefault.setValue(activeTextField!.text, forKey: "item two")
        case 3:
            let item = ToDo(title: activeTextField!.text!, completed: false)
            let itemDict = item.asDictionary
            let itemOneDatabaseRef = self.database.child("3")
            itemOneDatabaseRef.setValue(itemDict)
            
            userDefault.setValue(activeTextField!.text, forKey: "item three")
        default: break
        }
        return false
    }
    
    // MARK: - Lazy Instances
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(addToMirror), for: .touchUpInside)
        let image = UIImage(named: "Add Filled-50")
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var toDoListTableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 70
        return tableView
    }()
    
    lazy var textFieldOne: UITextField = {
        let field = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        field.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        field.autocorrectionType = .yes
        field.keyboardType = .default
        field.returnKeyType = .done
        field.borderStyle = UITextBorderStyle.none
        field.contentVerticalAlignment = .center
        field.layer.cornerRadius = 9
        field.tag = 1
        field.font = UIFont(name: "Code-Pro-Demo", size: 20)
        return field
    }()
    
    lazy var textFieldTwo: UITextField = {
        let field = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        field.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        field.autocorrectionType = .yes
        field.keyboardType = .default
        field.returnKeyType = .done
        field.borderStyle = UITextBorderStyle.none
        field.contentVerticalAlignment = .center
        field.layer.cornerRadius = 9
        field.tag = 2
        field.font = UIFont(name: "Code-Pro-Demo", size: 20)
        return field
    }()
    
    lazy var textFieldThree: UITextField = {
        let field = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        field.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        field.autocorrectionType = .yes
        field.keyboardType = .default
        field.returnKeyType = .done
        field.borderStyle = UITextBorderStyle.none
        field.contentVerticalAlignment = .center
        field.layer.cornerRadius = 9
        field.tag = 3
        field.font = UIFont(name: "Code-Pro-Demo", size: 20)
        return field
    }()
    
    lazy var checkBoxOne: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        button.addTarget(self, action: #selector(checkOffItemOne), for: .touchUpInside)
        return button
    }()
    
    lazy var checkBoxTwo: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        button.addTarget(self, action: #selector(checkOffItemTwo), for: .touchUpInside)
        return button
    }()
    
    lazy var checkBoxThree: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        button.addTarget(self, action: #selector(checkOffItemThree), for: .touchUpInside)
        return button
    }()
    
    lazy var checkMarkOne: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Checkmark")
        return view
    }()
    
    lazy var checkMarkTwo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Checkmark")
        return view
    }()
    
    lazy var checkMarkThree: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Checkmark")
        return view
    }()
}
