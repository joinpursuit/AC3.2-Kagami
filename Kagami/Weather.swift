//
//  Weather.swift
//  Kagami
//
//  Created by Eric Chang on 3/6/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

struct Weather {
    var type: String
    var location: String
    
    init(type: String, location: String) {
        self.type = type
        self.location = location
    }
    
    var asDictionary: [String: String] {
        return ["type": type,
                "location": location]
    }

}
