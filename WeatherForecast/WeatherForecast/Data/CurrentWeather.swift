//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by 호싱잉, 잼킹 on 2021/09/28.
//

import Foundation

struct CurrentWeather: Codable {
    let coordinate: Coordinate
    let weather: [Weather]
    let base: String
    let mainInfo: MainInfo
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    
    enum CodingKeys: String, CodingKey {
        case weather, base, visibility, wind, clouds, dt, sys, timezone, id, name, cod
        case coordinate = "coord"
        case mainInfo = "main"
    }
    
    struct Coordinate: Codable {
        let longitude: Double
        let latitude: Double
        
        enum CodingKeys: String, CodingKey {
            case longitude = "lon"
            case latitude = "lat"
        }
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct MainInfo: Codable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp, pressure, humidity
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
    }
    
    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }
    
    struct Clouds: Codable {
        let all: Int
    }
    
    struct Sys: Codable {
        let type: Int
        let id: Int
        let message: Double?
        let country: String
        let sunrise: Int
        let sunset: Int
    }
    
}
