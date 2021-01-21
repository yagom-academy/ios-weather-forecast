//
//  CurrentWeatherResponse.swift
//  WeatherForecast
//
//  Created by 임성민 on 2021/01/19.
//

import Foundation

struct CurrentWeather: Decodable {
    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
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
    
    enum AdditionalInfoKeys: String, CodingKey {
        case pressure, humidity
        case temperature = "temp"
        case temperatureFeelsLike = "feels_like"
        case temperatureMinimum = "temp_min"
        case temperatureMaximum = "temp_max"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coordinate = try values.decode(Coordinate.self, forKey: .coordinate)
        weather = try values.decode([Weather].self, forKey: .weather)
        base = try values.decode(String.self, forKey: .base)
        visibility = try values.decode(Int.self, forKey: .visibility)
        wind = try values.decode(Wind.self, forKey: .wind)
        clouds = try values.decode(Clouds.self, forKey: .clouds)
        dateTime = try values.decode(Int.self, forKey: .dateTime)
        system = try values.decode(System.self, forKey: .system)
        timezone = try values.decode(Int.self, forKey: .timezone)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        code = try values.decode(Int.self, forKey: .code)
        
        let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .main)
        pressure = try additionalInfo.decode(Int.self, forKey: .pressure)
        humidity = try additionalInfo.decode(Int.self, forKey: .humidity)
        let temperatureValue = try additionalInfo.decode(Double.self, forKey: .temperature)
        let temperatureFeelsLikeValue = try additionalInfo.decode(Double.self, forKey: .temperatureFeelsLike)
        let temperatureMinimum = try additionalInfo.decode(Double.self, forKey: .temperatureMinimum)
        let temperatureMaximum = try additionalInfo.decode(Double.self, forKey: .temperatureMaximum)
        temperature = Temperature(value: temperatureValue, feelsLikeValue: temperatureFeelsLikeValue, minimumValue: temperatureMinimum, maximumValue: temperatureMaximum, kfValue: nil)
    }
}
