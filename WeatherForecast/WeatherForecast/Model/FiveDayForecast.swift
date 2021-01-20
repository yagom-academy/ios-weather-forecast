//
//  FiveDayForecastResponse.swift
//  WeatherForecast
//
//  Created by 임성민 on 2021/01/19.
//

import Foundation

struct FiveDayForecast: Decodable {
    struct Forcast: Decodable {
        struct System: Decodable {
            let partOfTheDay: String
            
            enum CodingKeys: String, CodingKey {
                case partOfTheDay = "pod"
            }
        }
        
        let dateTime: Int
        let weather: [CurrentWeather.Weather]
        let clouds: CurrentWeather.Clouds
        let wind: CurrentWeather.Wind
        let visibility: Int
        let probabilityPrecipitation: Double
        let system: System
        let dateTimeText: String
        
        enum CodingKeys: String, CodingKey {
            case main, weather, clouds, wind, visibility
            case dateTime = "dt"
            case probabilityPrecipitation = "pop"
            case system = "sys"
            case dateTimeText = "dt_txt"
        }
    }
    
    struct City: Decodable {
        let id: Int
        let name: String
        let coordinate: CurrentWeather.Coordinate
        let country: String
        let population: Int
        let timezone: Int
        let sunrise: Int
        let sunset: Int
        
        enum CodingKeys: String, CodingKey {
            case id, name, country, population, timezone, sunrise, sunset
            case coordinate = "coord"
        }
    }
        
    let code: String
    let message: Int
    let count: Int
    let forcasts: [Forcast]
    let city: City
    
    enum CodingKeys: String, CodingKey {
        case message, city
        case code = "cod"
        case count = "cnt"
        case forcasts = "list"
    }
}
