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

class ToDoView: UIView, UITextFieldDelegate/*, UITableViewDelegate, UITableViewDataSource*/ {
    
//    var toDoList = ToDo.getMockData()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textFieldOne.delegate = self
        setupView()
//        toDoListTableView.delegate = self
//        toDoListTableView.dataSource = self
//        toDoListTableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.identifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up Hierarchy & constraints
    
    func setupView() {
//        self.addSubview(toDoListTableView)
        self.addSubview(button)
        self.addSubview(backgroundView)
        self.addSubview(textFieldOne)
        self.addSubview(textFieldTwo)
        self.addSubview(textFieldThree)
        
        button.snp.makeConstraints { (view) in
            view.left.right.bottom.equalToSuperview()
        }
//        toDoListTableView.snp.makeConstraints { (view) in
//            view.top.left.right.equalToSuperview()
//            view.bottom.equalTo(button.snp.top)
//        }
        backgroundView.snp.makeConstraints { (view) in
            view.top.bottom.left.right.equalToSuperview()
        }
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
    }
    /*
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = toDoListTableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier, for: indexPath) as! ToDoTableViewCell
        
        if indexPath.row < toDoList.count
        {
            let item = toDoList[indexPath.row]
            cell.textLabel?.text = item.title
            
            let accessory: UITableViewCellAccessoryType = item.isComplete ? .checkmark : .none
            cell.accessoryType = accessory
        }
        
        return cell
    }*/
    
    func addItem() {
        print("add to tableview")
    }
    
    // MARK: - Lazy Instances
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Add item", for: .normal)
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
        field.placeholder = "TO DO"
        field.autocorrectionType = .yes
        field.keyboardType = .default
        field.returnKeyType = .done
        field.borderStyle = UITextBorderStyle.none
        field.contentVerticalAlignment = .center
        return field
    }()
    
    lazy var textFieldTwo: UITextField = {
        let field = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        field.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        field.placeholder = "TO DO"
        field.autocorrectionType = .yes
        field.keyboardType = .default
        field.returnKeyType = .done
        field.borderStyle = UITextBorderStyle.none
        field.contentVerticalAlignment = .center
        return field
    }()
    
    lazy var textFieldThree: UITextField = {
        let field = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        field.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        field.placeholder = "TO DO"
        field.autocorrectionType = .yes
        field.keyboardType = .default
        field.returnKeyType = .done
        field.borderStyle = UITextBorderStyle.none
        field.contentVerticalAlignment = .center
        return field
    }()
}
