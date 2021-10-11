//
//  ForecastWeather.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/09/30.
//

import Foundation

struct ForecastWeather: Decodable {
    let list: [List]

    struct List: Decodable {
        let dataReceivingTime: TimeInterval
        let main: Main
        let weather: [Weather]
        let clouds: Clouds?
        let wind: Wind?
        let visibility: Int
        let probabilityOfPrecipitation: Double
        let rain: Rain?
        let snow: Snow?
        let dataReceivingTimeText: String?

        enum CodingKeys: String, CodingKey {
            case main, weather, clouds, wind, visibility, rain, snow
            case dataReceivingTime = "dt"
            case probabilityOfPrecipitation = "pop"
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

    struct Clouds: Decodable {
        let all: Int
    }

    struct Wind: Decodable {
        let speed: Double
        let deg: Double
        let gust: Double?
    }

    struct Rain: Decodable {
        let threeHour: Double?

        enum CodingKeys: String, CodingKey {
            case threeHour = "3h"
        }
    }

    struct Snow: Decodable {
        let threeHour: Double?

        enum CodingKeys: String, CodingKey {
            case threeHour = "3h"
        }
    }

}
