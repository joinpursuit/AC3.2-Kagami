//
//  Clock.swift
//  Kagami
//
//  Created by Eashir Arafat on 3/6/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

struct Clock {
  var time: String
  
  init(time: String) {
    self.time = time
  }
  
  var asDictionary: [String: String] {
    return ["time": time]
  }

}
