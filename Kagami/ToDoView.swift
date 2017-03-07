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

class ToDoView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var toDoList = ToDo.getMockData()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        toDoListTableView.delegate = self
        toDoListTableView.dataSource = self
        toDoListTableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.identifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up Hierarchy & constraints
    
    func setupView() {
        self.addSubview(toDoListTableView)
        self.addSubview(button)
        
        button.snp.makeConstraints { (view) in
            view.centerX.bottom.equalToSuperview()
        }
        toDoListTableView.snp.makeConstraints { (view) in
            view.top.left.right.equalToSuperview()
            view.bottom.equalTo(button.snp.top)
        }
    }
    
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
    }
    
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
}
