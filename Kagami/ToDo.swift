//
//  ToDo.swift
//  Kagami
//
//  Created by Annie Tung on 3/7/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit

class ToDo: Widgetable {
    
    var title: String
    var completed: Bool
    var category: String = "toDo"
    var iconImage: UIImage = #imageLiteral(resourceName: "checklist-icon")
    var description: String = "toDo"
    
    init(title: String, completed: Bool) {
        self.title = title
        self.completed = completed
    }
    
    var asDictionary: [String:Any] {
        return ["title" : title, "completed" : completed]
    }
}
