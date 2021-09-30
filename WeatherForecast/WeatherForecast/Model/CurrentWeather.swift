//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/09/30.
//

import Foundation

struct CurrentWeather: Decodable {
    let coordinate: Coordinate
    let weather: [Weather]
    let base: String
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let rain: Rain?
    let snow: Snow?
    let dataReceivingTime: TimeInterval
    let system: System
    let timezone: TimeInterval
    let id: Int
    let name: String
    let cod: Int

    enum CodingKeys: String, CodingKey {
        case weather, base, main, wind, clouds, rain, snow, timezone, id, name, cod
        case coordinate = "coord"
        case dataReceivingTime = "dt"
        case system = "sys"
    }

    struct Coordinate: Decodable {
        let lon: Double
        let lat: Double
    }

    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    struct Main: Decodable {
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

    struct Wind: Decodable {
        let speed: Double
        let deg: Double
        let gust: Double
    }

    struct Clouds: Decodable {
        let all: Int
    }

    struct Rain: Decodable {
        let oneHour: Double
        let threeHour: Double

        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
            case threeHour = "3h"
        }
    }

    struct Snow: Decodable {
        let oneHour: Double
        let threeHour: Double

        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
            case threeHour = "3h"
        }
    }

    struct System: Decodable {
        let type: Int
        let id: Int
        let message: Double?
        let country: String
        let sunrise: TimeInterval
        let sunset: TimeInterval
    }
}
