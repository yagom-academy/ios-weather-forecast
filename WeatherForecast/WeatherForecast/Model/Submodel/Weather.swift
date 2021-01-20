//
//  Weather.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/19.
//

import Foundation

struct Weather: Decodable {
    let conditionID: Int
    let group: String
    let iconID: String
    let description: String
    
    var iconURL: String {
        return "https://openweathermap.org/img/w/\(iconID).png"
    }
    
    enum CodingKeys: String, CodingKey {
        case conditionID = "id"
        case group = "main"
        case description
        case iconID = "icon"
    }
}
