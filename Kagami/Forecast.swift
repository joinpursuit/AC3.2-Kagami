//
//  Forecast.swift
//  Kagami
//
//  Created by Annie Tung on 3/14/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

//http://api.openweathermap.org/data/2.5/forecast?zip=11101&appid=93163a043d0bde0df1a79f0fdebc744f

class Forecast {
    
    var description: String
    var temperature: Int
    var minTemp: Int
    var maxTemp: Int
    var humidity: Int
    var city: String
    
    init(description: String, temperature: Int, minTemp: Int, maxTemp: Int, humidity: Int, city: String) {
        self.description = description
        self.temperature = temperature
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.humidity = humidity
        self.city = city
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
                    guard let main = each["main"] as? [String:Any],
                    let temperature = main["temp"] as? Int,
                    let minTemp = main["temp_min"] as? Int,
                    let maxTemp = main["temp_max"] as? Int,
                    let humidity = main["humidity"] as? Int,
                    let weather = each["weather"] as? [[String:Any]],
                    let description = weather[0]["description"] as? String else {
                        print("Error parsing each list")
                        return nil
                    }
                    
                let forecastObj = Forecast(description: description, temperature: temperature, minTemp: minTemp, maxTemp: maxTemp, humidity: humidity, city: cityName)
                forecastObject.append(forecastObj)
                dump(forecastObject)
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
