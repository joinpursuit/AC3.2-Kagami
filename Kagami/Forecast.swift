//
//  Forecast.swift
//  Kagami
//
//  Created by Annie Tung on 3/14/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

//http://api.openweathermap.org/data/2.5/forecast/daily?zip=11101&appid=93163a043d0bde0df1a79f0fdebc744f&cnt=5&units=imperial

class Forecast {
    
    var name: String
    var date: Double
    var min: Int
    var max: Int
    var description: String
    
    init(name: String, date: Double, min: Int, max: Int, description: String) {
        self.name = name
        self.date = date
        self.min = min
        self.max = max
        self.description = description
    }
    
    static func parseForecast(from data: Data?) -> [Forecast]? {
        guard let validData = data else { return nil }
        var forecastObject: [Forecast] = []
        
        do {
            if let json = try JSONSerialization.jsonObject(with: validData, options: []) as? [String:Any] {
                
                guard let list = json["list"] as? [[String:Any]] else {
                    print("Error casting at top level")
                    return nil
                }
                
                let city = json["city"] as? [String:Any]
                let cityName = city?["name"] as? String ?? "no city name"
                
                for each in list {
                    guard
                        let date = each["dt"] as? Double,
                        let temp = each["temp"] as? [String:Int],
                        let min = temp["min"],
                        let max = temp["max"],
                        let weather = each["weather"] as? [[String:Any]],
                        let description = weather[0]["description"] as? String else {
                            print("Error parsing each list")
                            return nil
                    }
                    
                    let forecastObj = Forecast(name: cityName, date: date, min: min, max: max, description: description)
                    forecastObject.append(forecastObj)
                }
            }
        }
        catch {
            print("Error parsing json: \(error.localizedDescription)")
            return nil
        }
        return forecastObject
    }
}
