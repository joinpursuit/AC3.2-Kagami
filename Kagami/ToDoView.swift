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
    
    var database: FIRDatabaseReference!
    var activeTextField: UITextField?
    let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.database = FIRDatabase.database().reference().child("toDos").child("lastest")
        textFieldOne.delegate = self
        textFieldTwo.delegate = self
        textFieldThree.delegate = self
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up Hierarchy & constraints
    
    func setupView() {
        self.addSubview(button)
        self.addSubview(backgroundView)
        self.addSubview(textFieldOne)
        self.addSubview(textFieldTwo)
        self.addSubview(textFieldThree)
        self.addSubview(checkBoxOne)
        self.addSubview(checkBoxTwo)
        self.addSubview(checkBoxThree)
        checkMarkView.addSubview(checkMark)
    }
    
    func setupConstraints() {
        button.snp.makeConstraints { (view) in
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
        checkBoxOne.snp.makeConstraints { (view) in
            view.top.equalTo(textFieldOne.snp.top).inset(8)
            view.trailing.equalTo(textFieldOne.snp.trailing).inset(8)
            view.bottom.equalTo(textFieldOne.snp.bottom).inset(8)
            view.width.height.equalTo(40)
        }
        checkBoxTwo.snp.makeConstraints { (view) in
            view.top.equalTo(textFieldTwo.snp.top).inset(8)
            view.trailing.equalTo(textFieldTwo.snp.trailing).inset(8)
            view.bottom.equalTo(textFieldTwo.snp.bottom).inset(8)
            view.width.height.equalTo(40)
        }
        checkBoxThree.snp.makeConstraints { (view) in
            view.top.equalTo(textFieldThree.snp.top).inset(8)
            view.trailing.equalTo(textFieldThree.snp.trailing).inset(8)
            view.bottom.equalTo(textFieldThree.snp.bottom).inset(8)
            view.width.height.equalTo(40)
        }
        
        // checkmark
        checkMark.snp.makeConstraints { (view) in
            view.top.bottom.leading.trailing.equalTo(checkMarkView)
        }
    }
    
    // MARK: - Methods
    
    func addItem() {
        print("add to mirror")
    }
    
    func checkOffItemOne() {
        if !checkBoxOne.subviews.contains(checkMarkView) {
            
            checkBoxOne.addSubview(checkMarkView)
            animateCheckMark()
            
        } else {
            checkMarkView.snp.removeConstraints()
        }
    }
    // MARK: - FIXME
    func checkOffItemTwo() {
        if !checkBoxTwo.subviews.contains(checkMark) {
            checkBoxTwo.addSubview(checkMark)
            checkMark.snp.makeConstraints { (view) in
                view.top.trailing.bottom.equalTo(textFieldTwo)
            }
        } else {
            checkMarkView.snp.removeConstraints()
        }
    }
    
    func checkOffItemThree() {
        if !checkBoxThree.subviews.contains(checkMark) {
            checkBoxThree.addSubview(checkMark)
            checkMark.snp.makeConstraints { (view) in
                view.top.trailing.bottom.equalTo(textFieldThree)
            }
        } else {
            checkMarkView.snp.removeConstraints()
        }
    }
    
    func animateCheckMark() {
        checkMarkView.snp.makeConstraints { (view) in
            view.centerX.centerY.equalTo(checkBoxOne)
        }
        animator.addAnimations{
            self.checkMarkView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        animator.addAnimations {
            self.layoutIfNeeded()
        }
        animator.startAnimation()
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
        
        if activeTextField!.tag == 1 {
            let item = ToDo(title: activeTextField!.text!, completed: false)
            let itemDict = item.asDictionary
            
            let itemOneDatabaseRef = self.database.child("1")
            itemOneDatabaseRef.setValue(itemDict)
        }
        else if activeTextField!.tag == 2 {
            let item = ToDo(title: activeTextField!.text!, completed: false)
            let itemDict = item.asDictionary
            
            let itemOneDatabaseRef = self.database.child("2")
            itemOneDatabaseRef.setValue(itemDict)
        }
        else if activeTextField!.tag == 3 {
            let item = ToDo(title: activeTextField!.text!, completed: false)
            let itemDict = item.asDictionary
            
            let itemOneDatabaseRef = self.database.child("3")
            itemOneDatabaseRef.setValue(itemDict)
        }
        return false
    }
    
    // MARK: - Lazy Instances
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Add To Mirror", for: .normal)
        button.setTitleColor(ColorPalette.blackColor, for: .normal)
        button.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        return button
    }()
    
    lazy var toDoListTableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 70
        return tableView
    }()
    
    lazy var backgroundView: UIImageView = {
        let view = UIImageView()
        let im = UIImage(named: "checklist-bg")
        view.image = im
        view.contentMode = .scaleAspectFill
        view.alpha = 0.6
        return view
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
        return field
    }()
    
    lazy var checkBoxOne: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorPalette.whiteColor
        button.addTarget(self, action: #selector(checkOffItemOne), for: .touchUpInside)
        return button
    }()
    
    lazy var checkBoxTwo: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorPalette.whiteColor
        button.addTarget(self, action: #selector(checkOffItemTwo), for: .touchUpInside)
        return button
    }()
    
    lazy var checkBoxThree: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorPalette.whiteColor
        button.addTarget(self, action: #selector(checkOffItemThree), for: .touchUpInside)
        return button
    }()
    
    lazy var checkMark: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Checkmark")
        return view
    }()
    
    lazy var checkMarkView: UIView = {
        let view = UIView()
        return view
    }()
}
