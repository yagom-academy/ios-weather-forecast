//
//  FiveDayForecastResponse.swift
//  WeatherForecast
//
//  Created by 임성민 on 2021/01/19.
//

import Foundation

struct FiveDayForecastResponse: Decodable {
    struct Forcast: Decodable {
        struct Main: Decodable {
            let temperature: Double
            let temperatureFeelsLike: Double
            let temperatureMinimum: Double
            let temperatureMaximum: Double
            let pressure: Int
            let humidity: Int
            let seaLevel: Int
            let groundLevel: Int
            let temperatureKF: Double
            
            enum CodingKeys: String, CodingKey {
                case pressure, humidity
                case temperature = "temp"
                case temperatureFeelsLike = "feels_like"
                case temperatureMinimum = "temp_min"
                case temperatureMaximum = "temp_max"
                case seaLevel = "sea_level"
                case groundLevel = "grnd_level"
                case temperatureKF = "temp_kf"
            }
        }
        
        struct System: Decodable {
            let partOfTheDay: String
            
            enum CodingKeys: String, CodingKey {
                case partOfTheDay = "pod"
            }
        }
        
        let dateTime: Int
        let main: Main
        let weather: [CurrentWeatherResponse.Weather]
        let clouds: CurrentWeatherResponse.Clouds
        let wind: CurrentWeatherResponse.Wind
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
        let coordinate: CurrentWeatherResponse.Coordinate
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
