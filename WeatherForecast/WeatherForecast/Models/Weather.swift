//
//  Weather.swift
//  WeatherForecast
//
//  Created by Theo on 2021/10/21.
//

import Foundation

struct Weather: Decodable {
    let iconName: String
    
    enum CodingKeys: String, CodingKey {
        case iconName = "icon"
    }
}
