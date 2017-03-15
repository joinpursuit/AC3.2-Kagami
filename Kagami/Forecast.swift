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
    
    convenience init?(from dict: [String:Any]) {
        let list = dict["list"] as? [[String:Any]]
        let main = list?[0]["main"] as? [String:Any]
        let temperature = main?["temp"] as? Int ?? 0
        let minTemp = main?["temp_min"] as? Int ?? 0
        let maxTemp = main?["temp_max"] as? Int ?? 0
        let humidity = main?["humidity"] as? Int ?? 0
        let weather = list?[0]["weather"] as? [[String:Any]]
        let description = weather?[0]["description"] as? String ?? "None"
        let city = dict["city"] as? [String:Any]
        let name = city?["name"] as? String ?? "No city available"
        
        self.init(description: description, temperature: temperature, minTemp: minTemp, maxTemp: maxTemp, humidity: humidity, city: name)
    }
    
    static func parseForecast(from: Data?) -> Forecast? {
        
        let data = try? JSONSerialization.jsonObject(with: from!, options: [])
        guard let validJson = data as? [String: Any] else { return nil }
        
        return Forecast(from: validJson)
    }
}
