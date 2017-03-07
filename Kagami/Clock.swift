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
  
  init(timeFormat: String) {
    self.timeFormat = timeFormat
  }
  
  var asDictionary: [String: String] {
    return ["timeFormat": timeFormat]
  }

}
