//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/18.
//

import Foundation

struct CurrentWeather: Codable {
    let addressName: String
    struct Weather: Codable {
        let iconName: String
        
        enum CodingKeys: String, CodingKey {
            case iconName = "icon"
        }
    }
    struct Main: Codable {
        let temperature: Double
        let minTemperature: Double
        let maxTemperature: Double
        
        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
            case minTemperature = "temp_min"
            case maxTemperature = "temp_max"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case addressName = "name"
    }
}
