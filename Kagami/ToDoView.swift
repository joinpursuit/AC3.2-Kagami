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
        
        self.backgroundColor = UIColor.white
        self.alpha = 0.8
        self.layer.cornerRadius = 9
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up Hierarchy & constraints
    
    func setupView() {
        self.addSubview(doneButton)
        self.addSubview(cancelButton)
        self.addSubview(textFieldOne)
        self.addSubview(textFieldTwo)
        self.addSubview(textFieldThree)
        self.addSubview(headerImage)
        
        self.addSubview(checkBoxOne)
        self.addSubview(checkBoxTwo)
        self.addSubview(checkBoxThree)
        
        checkBoxOne.addTarget(self, action: #selector(checkOffItemOne), for: .touchUpInside)
        checkBoxTwo.addTarget(self, action: #selector(checkOffItemTwo), for: .touchUpInside)
        checkBoxThree.addTarget(self, action: #selector(checkOffItemThree), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(addToMirror), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        doneButton.snp.makeConstraints { (view) in
            view.right.equalTo(self.snp.right).inset(8)
            view.bottom.equalTo(self.snp.bottom).inset(8)
        }
        
        cancelButton.snp.makeConstraints { (view) in
            view.left.equalTo(self.snp.left).inset(8)
            view.bottom.equalTo(self.snp.bottom).inset(8)
        }
        
        headerImage.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalTo(self.snp.top).inset(50)
        }
        
        // textfields
        textFieldOne.snp.makeConstraints { (field) in
            field.top.equalTo(headerImage.snp.bottom).offset(40)
            field.leading.equalTo(self.snp.leading).inset(10)
            field.height.equalTo(self.snp.height).multipliedBy(0.08)
            field.width.equalTo(self.snp.width).multipliedBy(0.75)
        }
        textFieldTwo.snp.makeConstraints { (field) in
            field.top.equalTo(textFieldOne.snp.bottom).offset(25)
            field.leading.equalTo(textFieldOne.snp.leading)
            field.height.equalTo(self.snp.height).multipliedBy(0.08)
            field.width.equalTo(self.snp.width).multipliedBy(0.75)
        }
        textFieldThree.snp.makeConstraints { (field) in
            field.top.equalTo(textFieldTwo.snp.bottom).offset(25)
            field.leading.equalTo(textFieldTwo.snp.leading)
            field.height.equalTo(self.snp.height).multipliedBy(0.08)
            field.width.equalTo(self.snp.width).multipliedBy(0.75)
        }
        
        // checkboxes
        checkBoxOne.snp.makeConstraints { (make) in
            make.left.equalTo(textFieldOne.snp.right).offset(8)
            make.right.equalTo(self).inset(10)
            make.top.equalTo(textFieldOne.snp.top)
            make.bottom.equalTo(textFieldOne.snp.bottom)
            make.height.width.equalTo(40)
        }
        checkBoxTwo.snp.makeConstraints { (make) in
            make.left.equalTo(textFieldTwo.snp.right).offset(8)
            make.right.equalTo(self).inset(10)
            make.top.equalTo(textFieldTwo.snp.top)
            make.bottom.equalTo(textFieldTwo.snp.bottom)
            make.height.width.equalTo(40)
        }
        checkBoxThree.snp.makeConstraints { (make) in
            make.left.equalTo(textFieldThree.snp.right).offset(8)
            make.right.equalTo(self).inset(10)
            make.top.equalTo(textFieldThree.snp.top)
            make.bottom.equalTo(textFieldThree.snp.bottom)
            make.height.width.equalTo(40)
        }
    }
    
    // MARK: - Methods
    
    func addToMirror() {
        print("add to mirror")
        
        let item1 = ToDo(title: textFieldOne.text!, completed: false)
        let itemDict1 = item1.asDictionary
        let itemOneDatabaseRef = self.database.child("1")
        itemOneDatabaseRef.setValue(itemDict1)
        userDefault.setValue(textFieldOne.text, forKey: "item one")
        
        if checkBoxOne.image(for: .normal) == UIImage(named:"checked") {
            let item = ToDo(title: textFieldOne.text!, completed: true)
            let itemDict = item.asDictionary
            itemOneDatabaseRef.setValue(itemDict)
            userDefault.setValue(true, forKey: "item one completed")
        } else {
            let item = ToDo(title: textFieldOne.text!, completed: false)
            let itemDict = item.asDictionary
            itemOneDatabaseRef.setValue(itemDict)
            userDefault.setValue(false, forKey: "item one completed")
        }
        dump("saving user default: \(userDefault.object(forKey: "item one completed") as! Bool)")
        
        let item2 = ToDo(title: textFieldTwo.text!, completed: false)
        let itemDict2 = item2.asDictionary
        let itemTwoDatabaseRef = self.database.child("2")
        itemTwoDatabaseRef.setValue(itemDict2)
        userDefault.setValue(textFieldTwo.text, forKey: "item two")
        
        if checkBoxTwo.image(for: .normal) == UIImage(named:"checked") {
            let item = ToDo(title: textFieldTwo.text!, completed: true)
            let itemDict = item.asDictionary
            itemTwoDatabaseRef.setValue(itemDict)
            userDefault.setValue(true, forKey: "item two completed")
        } else {
            let item = ToDo(title: textFieldTwo.text!, completed: false)
            let itemDict = item.asDictionary
            itemTwoDatabaseRef.setValue(itemDict)
            userDefault.setValue(false, forKey: "item two completed")
        }
        dump("saving user default: \(userDefault.object(forKey: "item two completed") as! Bool)")
        
        let item3 = ToDo(title: textFieldThree.text!, completed: false)
        let itemDict3 = item3.asDictionary
        let itemThreeDatabaseRef = self.database.child("3")
        itemThreeDatabaseRef.setValue(itemDict3)
        userDefault.setValue(textFieldThree.text, forKey: "item three")
        
        if checkBoxThree.image(for: .normal) == UIImage(named:"checked") {
            let item = ToDo(title: textFieldThree.text!, completed: true)
            let itemDict = item.asDictionary
            itemThreeDatabaseRef.setValue(itemDict)
            userDefault.setValue(true, forKey: "item three completed")
        } else {
            let item = ToDo(title: textFieldThree.text!, completed: false)
            let itemDict = item.asDictionary
            itemThreeDatabaseRef.setValue(itemDict)
            userDefault.setValue(false, forKey: "item three completed")
        }
        dump("saving user default: \(userDefault.object(forKey: "item three completed") as! Bool)")
    }
    
    func cancelTapped() {
        print("return to home page")
    }
    
    func checkOffItemOne() {
        let itemOneDatabaseRef = self.database.child("1")
        if checkBoxOne.image(for: .normal) == UIImage(named: "checked") {
            checkBoxOne.setImage(UIImage(named: "unchecked"), for: .normal)
            let item = ToDo(title: textFieldOne.text!, completed: false)
            let itemDict = item.asDictionary
            itemOneDatabaseRef.setValue(itemDict)
            userDefault.setValue(false, forKey: "item one completed")
        } else {
            checkBoxOne.setImage(UIImage(named: "checked"), for: .normal)
            let item = ToDo(title: textFieldOne.text!, completed: true)
            let itemDict = item.asDictionary
            itemOneDatabaseRef.setValue(itemDict)
            userDefault.setValue(true, forKey: "item one completed")
        }
    }
    
    func checkOffItemTwo() {
        let itemTwoDatabaseRef = self.database.child("2")
        if checkBoxTwo.image(for: .normal) == UIImage(named: "checked") {
            checkBoxTwo.setImage(UIImage(named: "unchecked"), for: .normal)
            let item = ToDo(title: textFieldTwo.text!, completed: false)
            let itemDict = item.asDictionary
            itemTwoDatabaseRef.setValue(itemDict)
            userDefault.setValue(false, forKey: "item two completed")
        } else {
            checkBoxTwo.setImage(UIImage(named: "checked"), for: .normal)
            let item = ToDo(title: textFieldTwo.text!, completed: true)
            let itemDict = item.asDictionary
            itemTwoDatabaseRef.setValue(itemDict)
            userDefault.setValue(true, forKey: "item two completed")
        }
    }
    
    func checkOffItemThree() {
        let itemThreeDatabaseRef = self.database.child("3")
        if checkBoxThree.image(for: .normal) == UIImage(named: "checked") {
            checkBoxThree.setImage(UIImage(named: "unchecked"), for: .normal)
            let item = ToDo(title: textFieldThree.text!, completed: false)
            let itemDict = item.asDictionary
            itemThreeDatabaseRef.setValue(itemDict)
            userDefault.setValue(false, forKey: "item three completed")
        } else {
            checkBoxThree.setImage(UIImage(named: "checked"), for: .normal)
            let item = ToDo(title: textFieldThree.text!, completed: true)
            let itemDict = item.asDictionary
            itemThreeDatabaseRef.setValue(itemDict)
            userDefault.setValue(true, forKey: "item three completed")
        }
    }
    
    func loadUserDefaults() {
        if userDefault.object(forKey: "item one") != nil {
            textFieldOne.text = userDefault.object(forKey: "item one") as? String
            print(textFieldOne.text!)
        }
        if userDefault.object(forKey: "item one completed") != nil {
            let isCompleted = userDefault.object(forKey: "item one completed") as! Bool
            dump("user default: \(userDefault.object(forKey: "item one completed") as! Bool)")
            if isCompleted {
                checkBoxOne.setImage(UIImage(named:"checked"), for: .normal)
            } else {
                checkBoxOne.setImage(UIImage(named:"unchecked"), for: .normal)
            }
        }
        
        if userDefault.object(forKey: "item two") != nil {
            textFieldTwo.text = userDefault.object(forKey: "item two") as? String
            print(textFieldTwo.text!)
        }
        if userDefault.object(forKey: "item two completed") != nil {
            let isCompleted = userDefault.object(forKey: "item two completed") as! Bool
            dump("user default: \(userDefault.object(forKey: "item two completed") as! Bool)")
            if isCompleted {
                checkBoxTwo.setImage(UIImage(named:"checked"), for: .normal)
            } else {
                checkBoxTwo.setImage(UIImage(named:"unchecked"), for: .normal)
            }
        }
        
        if userDefault.object(forKey: "item three") != nil {
            textFieldThree.text = userDefault.object(forKey: "item three") as? String
            print(textFieldThree.text!)
        }
        
        if userDefault.object(forKey: "item three completed") != nil {
            let isCompleted = userDefault.object(forKey: "item three completed") as! Bool
            dump("user default: \(userDefault.object(forKey: "item three completed") as! Bool)")
            if isCompleted {
                checkBoxThree.setImage(UIImage(named:"checked"), for: .normal)
            } else {
                checkBoxThree.setImage(UIImage(named:"unchecked"), for: .normal)
            }
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
        self.endEditing(true)
        return false
    }
    
    // MARK: - Lazy Instances
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Ok-104")
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Cancel-104")
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var textFieldOne: UITextField = {
        let field = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        field.backgroundColor = ColorPalette.whiteColor
        field.autocorrectionType = .yes
        field.keyboardType = .default
        field.returnKeyType = .done
        field.borderStyle = UITextBorderStyle.none
        field.contentVerticalAlignment = .center
        field.layer.cornerRadius = 9
        field.tag = 1
        field.font = UIFont(name: "Code-Pro-Demo", size: 20)
        field.placeholder = "To Do"
        return field
    }()
    
    lazy var textFieldTwo: UITextField = {
        let field = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        field.backgroundColor = ColorPalette.whiteColor
        field.autocorrectionType = .yes
        field.keyboardType = .default
        field.returnKeyType = .done
        field.borderStyle = UITextBorderStyle.none
        field.contentVerticalAlignment = .center
        field.layer.cornerRadius = 9
        field.tag = 2
        field.font = UIFont(name: "Code-Pro-Demo", size: 20)
        field.placeholder = "To Do"
        return field
    }()
    
    lazy var textFieldThree: UITextField = {
        let field = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        field.backgroundColor = ColorPalette.whiteColor
        field.autocorrectionType = .yes
        field.keyboardType = .default
        field.returnKeyType = .done
        field.borderStyle = UITextBorderStyle.none
        field.contentVerticalAlignment = .center
        field.layer.cornerRadius = 9
        field.tag = 3
        field.font = UIFont(name: "Code-Pro-Demo", size: 20)
        field.placeholder = "To Do"
        return field
    }()
    
    lazy var checkBoxOne: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.setImage(UIImage(named:"unchecked"), for: .normal)
        return button
    }()
    
    lazy var checkBoxTwo: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.setImage(UIImage(named:"unchecked"), for: .normal)
        return button
    }()
    
    lazy var checkBoxThree: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.setImage(UIImage(named:"unchecked"), for: .normal)
        return button
    }()
    
    lazy var headerImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "todoheader")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
}
