//
//  ForecastWeather.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/09/30.
//

import Foundation

struct ForecastWeather: Decodable {
    let list: [List]
    let city: City

    struct List: Decodable {
        let dataReceivingTime: TimeInterval
        let main: Main
        let weather: [Weather]
        let dataReceivingTimeText: String

        enum CodingKeys: String, CodingKey {
            case main, weather
            case dataReceivingTime = "dt"
            case dataReceivingTimeText = "dt_txt"
        }
    }

    struct Main: Decodable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let seaLevel: Int
        let grndLevel: Int
        let humidity: Int
        let tempKF: Double

        enum CodingKeys: String, CodingKey {
            case temp, pressure, humidity
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
            case tempKF = "temp_kf"
        }
    }

    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    struct City: Decodable {
        let id: Int
        let name: String
        let coordinate: Coordinate?
        let country: String

        enum Codingkeys: String, CodingKey {
            case id, name, country
            case coordinate = "coord"
        }
    }
}
