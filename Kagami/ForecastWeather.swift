//
//  ForecastWeather.swift
//  Kagami
//
//  Created by Marcel Chaucer on 3/1/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

class ForecastWeather {
    var minTemperature: Int
    var maxTemperature: Int
    var icon: String
    var mainCondition: String
    var description: String
    
    init(minTemperature: Int, maxTemperature: Int, icon: String, mainCondition: String, description: String) {
        
        self.minTemperature = minTemperature
        self.maxTemperature = maxTemperature
        self.icon = icon
        self.mainCondition = mainCondition
        self.description = description
    }
    
    convenience init?(from dictionary: [String:Any])  {
            let mainWeather = dictionary["main"] as! [String: Int]
            //Max and Min Temps
            let minTemperature = mainWeather["temp_min"]
            let maxTemperature = mainWeather["temp_max"]
        
            //Weather Descriptions
            let weatherDescription = dictionary["weather"] as! [[String: Any]]
        
            let icon = weatherDescription[0]["icon"] as! String
            let mainCondition = weatherDescription[0]["main"] as! String
            let description = weatherDescription[0]["description"] as! String
        
        self.init(minTemperature: minTemperature!, maxTemperature : maxTemperature!, icon: icon, mainCondition: mainCondition, description : description)
        
    }
    
    
    static func parseForecast(from: Data?) -> [ForecastWeather]? {
        var nextFiveDays: [ForecastWeather] = []
        
        
        let data = try? JSONSerialization.jsonObject(with: from!, options: [])
        guard let validJson = data as? [String: Any] else { return nil }
        guard let forecast = validJson["list"] as? [[String: Any]] else { return nil }
        
        
        for days in forecast {
            nextFiveDays.append(ForecastWeather(from: days)!)
        }
        
        return nextFiveDays
    }
    
}
