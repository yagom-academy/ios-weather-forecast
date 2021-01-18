//
//  Weather.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/19.
//

import Foundation

struct Weather: Codable {
    let iconID: String
    
    enum CodingKeys: String, CodingKey {
        case iconID = "icon"
    }
}
