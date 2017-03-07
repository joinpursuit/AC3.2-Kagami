//
//  Clock.swift
//  Kagami
//
//  Created by Eashir Arafat on 3/6/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

struct Clock {
  var militaryTime: Bool
  var timeZone: String
  
  init(militaryTime: Bool, timeZone: String) {
    self.militaryTime = militaryTime
    self.timeZone = timeZone
  }
  
  var asDictionary: [String: Any] {
    return ["militaryTime": militaryTime,
            "timeZone": timeZone]
  }

}
