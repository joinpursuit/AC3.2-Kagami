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
    var isComplete: Bool
    
    public init(title: String) {
        self.title = title
        self.isComplete = false
    }
}

extension ToDo {
    
    public class func getMockData() -> [ToDo] {
        return [
            ToDo(title: "Mirror Film"),
            ToDo(title: "Measure Monitor"),
            ToDo(title: "Get VGA Cord")
        ]
    }
}
