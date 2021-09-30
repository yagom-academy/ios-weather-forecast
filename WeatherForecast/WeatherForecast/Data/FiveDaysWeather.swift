//
//  FivedaysWeather.swift
//  WeatherForecast
//
//  Created by 호싱잉, 잼킹 on 2021/09/28.
//

import Foundation

struct FivedaysWeather: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [Item]
    let city: City
    
    struct Item: Codable {
        let dt: Int
        let mainInfo: MainInfo
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let visibility: Int
        let pop: Double
        let rain: Rain?
        let sys: Sys
        let dtTxt: String
        
        enum CodingKeys: String, CodingKey {
            case dt, weather, clouds, wind, visibility, pop, rain, sys
            case mainInfo = "main"
            case dtTxt = "dt_txt"
        }
        
        struct MainInfo: Codable {
            let temp: Double
            let feelsLike: Double
            let tempMin: Double
            let tempMax: Double
            let pressure: Int
            let seaLevel: Int
            let grndLevel: Int
            let humidity: Int
            let tempKf: Double
            
            enum CodingKeys: String, CodingKey {
                case temp, pressure ,humidity
                case feelsLike = "feels_like"
                case tempMin = "temp_min"
                case tempMax = "temp_max"
                case seaLevel = "sea_level"
                case grndLevel = "grnd_level"
                case tempKf = "temp_kf"
            }
        }
        
        struct Weather: Codable {
            let id: Int
            let main: String
            let description: String
            let icon: String
        }
        
        struct Wind: Codable {
            let speed: Double
            let deg: Int
            let gust: Double
        }
        
        struct Clouds: Codable {
            let all: Int
        }
        
        struct Rain: Codable {
            let threeHours: Double
            
            enum CodingKeys: String, CodingKey {
                case threeHours = "3h"
            }
        }
        
        struct Sys: Codable {
            let pod: String
        }
    }
    
    struct City: Codable {
        let id: Int
        let name: String
        let coordinate: Coordinate
        let country: String
        let population: Int
        let timezone: Int
        let sunrise: Int
        let sunset: Int
        
        struct Coordinate: Codable {
            let longitude: Double
            let latitude: Double
            
            enum CodingKeys: String, CodingKey {
                case longitude = "lon"
                case latitude = "lat"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case id, name, country, population, timezone, sunrise, sunset
            case coordinate = "coord"
        }
    }
}
