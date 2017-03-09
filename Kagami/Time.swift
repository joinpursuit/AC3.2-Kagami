//
//  Clock.swift
//  Kagami
//
//  Created by Eashir Arafat on 3/8/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//
import Foundation

struct Time {
  var militaryTime: Bool
  
  init(militaryTime: Bool) {
    self.militaryTime = militaryTime
  }
  
  var asDictionary: [String: Bool] {
    return ["militaryTime": militaryTime]
  }
  
}
