//
//  Weather.swift
//  Kagami
//
//  Created by Eric Chang on 3/6/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit

class Weather: Widgetable {
    
    var type: String
    var location: String
    var category: String = "weather"
    var iconImage: UIImage = #imageLiteral(resourceName: "cloud")
    var description: String = "weather"
    
    init(type: String, location: String) {
        self.type = type
        self.location = location
    }
    
    var asDictionary: [String: String] {
        return ["type": type,
                "location": location]
    }

}
