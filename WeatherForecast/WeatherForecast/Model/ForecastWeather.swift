//
//  ForecastWeather.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/09/30.
//

import Foundation

struct ForecastWeather: Decodable {
    var list: [List]

    struct List: Decodable, Equatable {
    
        let forecastTime: TimeInterval
        let main: Main
        let weather: [Weather]
        let probabilityOfPrecipitation: Double
        let dataReceivingTimeText: String?
        var iconData: Data?
        
        enum CodingKeys: String, CodingKey {
            case main, weather
            case forecastTime = "dt"
            case probabilityOfPrecipitation = "pop"
            case dataReceivingTimeText = "dt_txt"
        }
        
        static func == (lhs: ForecastWeather.List, rhs: ForecastWeather.List) -> Bool {
            guard let lhs = lhs.weather.first?.id,
                  let rhs = rhs.weather.first?.id else { return false }
            
            return lhs == rhs
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

}
