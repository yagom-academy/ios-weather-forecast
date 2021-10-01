//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by 호싱잉, 잼킹 on 2021/09/28.
//

import Foundation

struct CurrentWeather: Decodable {
    let coordinate: Coordinate
    let weather: [Weather]
    let base: String
    let mainInfo: MainInfo
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let partOfTheDay: Int
    let system: System
    let timezone: Int
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case weather, base, visibility, wind, clouds, timezone, id, name
        case partOfTheDay = "dt"
        case system = "sys"
        case coordinate = "coord"
        case mainInfo = "main"
    }
    
    struct Coordinate: Decodable {
        let longitude: Double
        let latitude: Double
        
        enum CodingKeys: String, CodingKey {
            case longitude = "lon"
            case latitude = "lat"
        }
    }
    
    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct MainInfo: Decodable {
        let temperature: Double
        let feelsLike: Double
        let temperatureMin: Double
        let temperatureMax: Double
        let pressure: Int
        let humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case pressure, humidity
            case temperature = "temp"
            case temperatureMin = "tempMin"
            case temperatureMax = "tempMax"
            case feelsLike = "feels_like"
        }
    }
    
    struct Wind: Decodable {
        let speed: Double
        let degree: Int
        
        enum CodingKeys: String, CodingKey {
            case speed
            case degree = "deg"
        }
    }
    
    struct Clouds: Decodable {
        let all: Int
    }
    
    struct System: Decodable {
        let type: Int
        let id: Int
        let message: Double?
        let country: String
        let sunrise: Int
        let sunset: Int
    }
    
}
