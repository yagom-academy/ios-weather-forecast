//
//  WeatherInformation.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/18.
//

import Foundation

struct WeatherInformation: Codable {
    let iconName: String
    
    enum CodingKeys: String, CodingKey {
        case iconName = "icon"
    }
}
