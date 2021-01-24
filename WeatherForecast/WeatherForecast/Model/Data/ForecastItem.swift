//
//  ForecastItem.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/18.
//

import Foundation

struct ForecastItem: Decodable{
    let dateTime: Date
    let temperature: Temperature
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case temperature = "main"
        case weather
    }
}

extension ForecastItem {
    var dateTimeToString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        
        return dateFormatter.string(from: self.dateTime)
    }
}
