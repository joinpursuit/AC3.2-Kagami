//
//  WordOfTheDay.swift
//  Kagami
//
//  Created by Marcel Chaucer on 3/2/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

class WordOfTheDay {
    var word: String
    var definition: String
    var partOfSpeech: String
    
    init(word: String, definition: String, partOfSpeech: String) {
        
        self.word = word
        self.definition = definition
        self.partOfSpeech = partOfSpeech
    }
    
//    convenience init?(from dictionary: [String:Any])  {
//        //Descriptions Of Weather
//        let weather = dictionary["weather"] as? [[String:Any]]
//        let mainCondition = weather?[0]["main"] as? String ?? "No Weather"
//        let weatherDescription = weather?[0]["description"] as? String ?? "No Description"
//        let icon = weather?[0]["icon"] as? String ?? "No Icon"
//        
//        //Main Temperature
//        let mainTemperature = dictionary["main"] as! [String: Int]
//        let temperature = mainTemperature["temp"]!
//        let pressure = mainTemperature["pressure"]!
//        let humidity = mainTemperature["humidity"]!
//        
//        self.init(temperature: temperature, icon: icon, mainCondition: mainCondition, weatherDescription: weatherDescription, pressure : pressure, humidity : humidity)
//    }
//    
//    static func parseWordOfDay(from: Data?) -> WordOfTheDay? {
//        
//        let data = try? JSONSerialization.jsonObject(with: from!, options: [])
//        guard let validJson = data as? [String: Any] else { return nil }
//        
//        return WordOfTheDay(from: validJson)
//    }
    
}
