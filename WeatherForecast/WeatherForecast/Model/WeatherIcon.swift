//
//  WeatherIcon.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/18.
//

import Foundation

struct WeatherIcon: Codable {
    let name: String
    let main: String
    let description: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case name = "icon"
        case main, description, id
    }
}
