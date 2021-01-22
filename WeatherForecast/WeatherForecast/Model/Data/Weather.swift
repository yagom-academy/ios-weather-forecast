//
//  WeatherInformation.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/18.
//

import Foundation

struct Weather: Decodable {
    let iconName: String
    
    enum CodingKeys: String, CodingKey {
        case iconName = "icon"
    }
}
