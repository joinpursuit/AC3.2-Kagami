//
//  ToDo.swift
//  Kagami
//
//  Created by Annie Tung on 3/7/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

class ToDo {
    
    var title: String
    var completed: Bool
    
    init(title: String, completed: Bool) {
        self.title = title
        self.completed = completed
    }
    
    var asDictionary: [String:Any] {
        return ["title" : title, "completed" : completed]
    }
}
