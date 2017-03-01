//
//  DailyWeather.swift
//  Kagami
//
//  Created by Marcel Chaucer on 3/1/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

class DailyWeather {
    var temperature: Int
    var icon: String
    var mainCondition: String
    var weatherDescription: String
    
    
    init(temperature: Int, icon: String, mainCondition: String, weatherDescription: String) {
        
        self.temperature = temperature
        self.icon = icon
        self.mainCondition = mainCondition
        self.weatherDescription = weatherDescription
    }
    
    convenience init?(from dictionary: [String:Any])  {
        //Descriptions Of Weather
        let weather = dictionary["weather"] as? [[String:Any]]
        
        let mainCondition = weather?[0]["main"] as? String ?? "No Weather"
        let weatherDescription = weather?[0]["description"] as? String ?? "No Description"
        let icon = weather?[0]["icon"] as? String ?? "No Icon"
        
        //Main Temperature
        let mainTemperature = dictionary["main"] as? [String: Int]
        let temperature = mainTemperature?["temp"]!
        
        
        self.init(temperature: temperature!, icon: icon, mainCondition: mainCondition, weatherDescription: weatherDescription)
    }
    
    
    static func parseWeather(from: Data?) -> DailyWeather? {
        
        let data = try? JSONSerialization.jsonObject(with: from!, options: [])
        guard let validJson = data as? [String: Any] else { return nil }
        
        return DailyWeather(from: validJson)
    }
    
}
