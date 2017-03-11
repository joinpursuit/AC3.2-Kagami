//
//  DailyWeather.swift
//  Kagami
//
//  Created by Marcel Chaucer on 3/1/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

//For temperature in Celsius use units=metric

//http://api.openweathermap.org/data/2.5/weather?appid=93163a043d0bde0df1a79f0fdebc744f&zip=11101,us&units=imperial

class DailyWeather {
    var temperature: Int
    var icon: String
    var mainCondition: String
    var weatherDescription: String
    var pressure: Int
    var humidity: Int
    var minTemp: Int
    var maxTemp: Int
    var name: String
    
    init(temperature: Int, icon: String, mainCondition: String, weatherDescription: String, pressure: Int, humidity: Int, minTemp: Int, maxTemp: Int, name: String) {
        
        self.temperature = temperature
        self.icon = icon
        self.mainCondition = mainCondition
        self.weatherDescription = weatherDescription
        self.pressure = pressure
        self.humidity = humidity
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.name = name
    }
    
    convenience init?(from dictionary: [String:Any])  {
        //Descriptions Of Weather
        let weather = dictionary["weather"] as? [[String:Any]]
        let mainCondition = weather?[0]["main"] as? String ?? "No Weather"
        let weatherDescription = weather?[0]["description"] as? String ?? "No Description"
        let icon = weather?[0]["icon"] as? String ?? "No Icon"
        
        //Main Temperature
        let mainTemperature = dictionary["main"] as! [String: Int]
        let temperature = mainTemperature["temp"]!
        let pressure = mainTemperature["pressure"]!
        let humidity = mainTemperature["humidity"]!
        let minTemp = mainTemperature["temp_min"]!
        let maxTemp = mainTemperature["temp_max"]!
        
        let name = dictionary["name"] as? String ?? "No city available"
        
        self.init(temperature: temperature, icon: icon, mainCondition: mainCondition, weatherDescription: weatherDescription, pressure : pressure, humidity : humidity, minTemp : minTemp, maxTemp : maxTemp, name : name)
    }
    
    static func parseWeather(from: Data?) -> DailyWeather? {
        
        let data = try? JSONSerialization.jsonObject(with: from!, options: [])
        guard let validJson = data as? [String: Any] else { return nil }
        
        return DailyWeather(from: validJson)
    }
    
}
