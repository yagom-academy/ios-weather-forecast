//
//  FiveDayForecastResponse.swift
//  WeatherForecast
//
//  Created by 임성민 on 2021/01/19.
//

import Foundation

struct FiveDayForecast: Decodable {
    struct Forecast: Decodable {
        struct System: Decodable {
            let partOfTheDay: String
            
            enum CodingKeys: String, CodingKey {
                case partOfTheDay = "pod"
            }
        }
        
        struct Temperature: Decodable {
            let value: Double
            let feelsLikeValue: Double
            let minimumValue: Double
            let maximumValue: Double
            let kfValue: Double
        }
        
        let dateTime: Int
        let weather: [CurrentWeather.Weather]
        let clouds: CurrentWeather.Clouds
        let wind: CurrentWeather.Wind
        let visibility: Int
        let pressure: Int
        let humidity: Int
        let seaLevel: Int
        let groundLevel: Int
        let temperature: Temperature
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
        
        enum AdditionalInfoKeys: String, CodingKey {
            case pressure, humidity
            case temperature = "temp"
            case temperatureFeelsLike = "feels_like"
            case temperatureMinimum = "temp_min"
            case temperatureMaximum = "temp_max"
            case seaLevel = "sea_level"
            case groundLevel = "grnd_level"
            case temperatureKF = "temp_kf"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            dateTime = try values.decode(Int.self, forKey: .dateTime)
            weather = try values.decode([CurrentWeather.Weather].self, forKey: .weather)
            clouds = try values.decode(CurrentWeather.Clouds.self, forKey: .clouds)
            wind = try values.decode(CurrentWeather.Wind.self, forKey: .wind)
            visibility = try values.decode(Int.self, forKey: .visibility)
            system = try values.decode(System.self, forKey: .system)
            dateTimeText = try values.decode(String.self, forKey: .dateTimeText)
            probabilityPrecipitation = try values.decode(Double.self, forKey: .probabilityPrecipitation)
            
            let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .main)
            pressure = try additionalInfo.decode(Int.self, forKey: .pressure)
            humidity = try additionalInfo.decode(Int.self, forKey: .humidity)
            seaLevel = try additionalInfo.decode(Int.self, forKey: .seaLevel)
            groundLevel = try additionalInfo.decode(Int.self, forKey: .groundLevel)
            let temperatureValue = try additionalInfo.decode(Double.self, forKey: .temperature)
            let temperatureFeelsLikeValue = try additionalInfo.decode(Double.self, forKey: .temperatureFeelsLike)
            let temperatureMinimum = try additionalInfo.decode(Double.self, forKey: .temperatureMinimum)
            let temperatureMaximum = try additionalInfo.decode(Double.self, forKey: .temperatureMaximum)
            let temperatureKF = try additionalInfo.decode(Double.self, forKey: .temperatureKF)
            temperature = Temperature(value: temperatureValue, feelsLikeValue: temperatureFeelsLikeValue, minimumValue: temperatureMinimum, maximumValue: temperatureMaximum, kfValue: temperatureKF)
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
        
        enum CodingKeys: String, CodingKey {
            case id, name, country, population, timezone, sunrise, sunset
            case coordinate = "coord"
        }
    }
        
    let code: String
    let message: Int
    let count: Int
    let forecasts: [Forecast]
    let city: City
    
    enum CodingKeys: String, CodingKey {
        case message, city
        case code = "cod"
        case count = "cnt"
        case forecasts = "list"
    }
}
