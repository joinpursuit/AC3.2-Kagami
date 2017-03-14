//
//  Clock.swift
//  Kagami
//
//  Created by Eashir Arafat on 3/8/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//
import UIKit

class Time: Widgetable {
    
    var militaryTime: Bool
    var category: String = "time"
    var iconImage: UIImage = #imageLiteral(resourceName: "clock-icon")
    var description: String = "time"
    
    init(militaryTime: Bool) {
        self.militaryTime = militaryTime
    }
    
    var asDictionary: [String: Bool] {
        return ["militaryTime": militaryTime]
    }
    
}
