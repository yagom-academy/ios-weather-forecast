//
//  FivedaysWeather.swift
//  WeatherForecast
//
//  Created by 호싱잉, 잼킹 on 2021/09/28.
//

import Foundation

struct FivedaysWeather: Decodable {
    let timeStampCount: Int
    let list: [Item]
    let city: City
    
    enum CodingKeys: String, CodingKey {
        case list, city
        case timeStampCount = "cnt"
    }
    
    struct Item: Decodable {
        let timeOfData: Int
        let mainInfo: MainInfo
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let visibility: Int
        let probabilityOfPrecipitation: Double
        let rain: Rain?
        let system: System
        let timeOfDataText: String
        
        enum CodingKeys: String, CodingKey {
            case weather, clouds, wind, visibility, rain
            case timeOfData = "dt"
            case mainInfo = "main"
            case probabilityOfPrecipitation = "pop"
            case timeOfDataText = "dt_txt"
            case system = "sys"
        }
        
        struct MainInfo: Decodable {
            let temperature: Double
            let feelsLike: Double
            let temperatureMin: Double
            let temperatureMax: Double
            let pressure: Int
            let seaLevel: Int
            let groundLevel: Int
            let humidity: Int
            let tempKf: Double
            
            enum CodingKeys: String, CodingKey {
                case pressure ,humidity
                case temperature = "temp"
                case feelsLike = "feels_like"
                case temperatureMin = "temp_min"
                case temperatureMax = "temp_max"
                case seaLevel = "sea_level"
                case groundLevel = "grnd_level"
                case tempKf = "temp_kf"
            }
        }
        
        struct Weather: Decodable {
            let id: Int
            let main: String
            let description: String
            let icon: String
        }
        
        struct Wind: Decodable {
            let speed: Double
            let degree: Int
            let gust: Double
           
            enum CodingKeys: String, CodingKey {
                case speed, gust
                case degree = "deg"
            }
        }
        
        struct Clouds: Decodable {
            let all: Int
        }
        
        struct Rain: Decodable {
            let threeHours: Double
            
            enum CodingKeys: String, CodingKey {
                case threeHours = "3h"
            }
        }
        
        struct System: Decodable {
            let partOfTheDay: String
            
            enum CodingKeys: String, CodingKey {
                case partOfTheDay = "pod"
            }
        }
    }
    
    struct City: Decodable {
        let id: Int
        let name: String
        let coordinate: Coordinate
        let country: String
        let population: Int
        let timezone: Int
        let sunrise: Int
        let sunset: Int
        
        struct Coordinate: Decodable {
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
