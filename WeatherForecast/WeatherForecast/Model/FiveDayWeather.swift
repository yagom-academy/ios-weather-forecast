//
//  FiveDayWeather.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/09/28.
//

import Foundation

struct FiveDayWeather: Decodable {
    let HTTPStatusCode: String
    let message: Double
    let timestampCount: Int
    let list: [List]
    let city: City
    
    enum CodingKeys: String, CodingKey {
        case message, list, city
        case HTTPStatusCode = "cod"
        case timestampCount = "cnt"
    }
    
    struct List: Decodable {
        let UnixForecastTime: Int
        let main: Main
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let rain: Rain?
        let sys: Sys
        let ISOForecastTime: String
        
        enum CodingKeys: String, CodingKey {
            case main, weather, clouds, wind, rain, sys
            case UnixForecastTime = "dt"
            case ISOForecastTime = "dt_txt"
        }
    }
    
    struct City: Decodable {
        let id: Int
        let name: String
        let coordinates: Coordinates
        let country: String
        
        enum CodingKeys: String, CodingKey {
            case id, name, country
            case coordinates = "coord"
        }
    }
    
    struct Rain: Decodable {
        let threeHoursVolume: Double
        
        enum CodingKeys: String, CodingKey {
            case threeHoursVolume = "3h"
        }
    }
    
    struct Sys: Decodable {
        let partOfDay: String
        
        enum CodingKeys: String, CodingKey {
            case partOfDay = "pod"
        }
    }
}
