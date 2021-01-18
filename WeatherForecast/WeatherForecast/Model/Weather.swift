//
//  Weather.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/19.
//

import Foundation

struct Weather: Codable {
    let iconID: String
    
    var iconURL: String {
        return "https://openweathermap.org/img/w/\(iconID).png"
    }
    
    enum CodingKeys: String, CodingKey {
        case iconID = "icon"
    }
}
