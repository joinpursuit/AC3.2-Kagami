//
//  Clock.swift
//  Kagami
//
//  Created by Eashir Arafat on 3/6/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

struct Clock {
  var timeFormat: String
  var timeZone: String
  
  init(timeFormat: String, timeZone: String) {
    self.timeFormat = timeFormat
    self.timeZone = timeZone
  }
  
  var asDictionary: [String: String] {
    return ["timeFormat": timeFormat,
            "timeZone": timeZone]
  }

}
