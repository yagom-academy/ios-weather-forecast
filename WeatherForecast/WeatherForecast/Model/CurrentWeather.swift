//
//  CurrentWeatherResponse.swift
//  WeatherForecast
//
//  Created by 임성민 on 2021/01/19.
//

import Foundation

struct CurrentWeather: Decodable {
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
    
    struct Temperature: Decodable {
        let value: Double
        let feelsLikeValue: Double
        let minimumValue: Double
        let maximumValue: Double
    }
    
    struct Wind: Decodable {
        let speed: Double
        let degree: Int
        let gust: Double?
        
        enum CodingKeys: String, CodingKey {
            case speed, gust
            case degree = "deg"
        }
    }
    
    struct Clouds: Decodable {
        let all: Int
    }
    
    struct System: Decodable {
        let type: Int
        let id: Int
        let country: String
        let sunrise: Int
        let sunset: Int
    }
    
    let coordinate: Coordinate
    let weather: [Weather]
    let base: String
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let pressure: Int
    let humidity: Int
    let temperature: Temperature
    let dateTime: Int
    let system: System
    let timezone: Int
    let id: Int
    let name: String
    let code: Int
    
    enum CodingKeys: String, CodingKey {
        case weather, base, main, visibility, wind, clouds, timezone, id, name
        case coordinate = "coord"
        case dateTime = "dt"
        case system = "sys"
        case code = "cod"
    }
}
