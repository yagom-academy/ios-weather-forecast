//
//  WeatherIcon.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/18.
//

import Foundation

struct WeatherIcon: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "icon"
    }
}
