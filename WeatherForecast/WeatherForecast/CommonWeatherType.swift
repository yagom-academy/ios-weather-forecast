//
//  CommonWeatherType.swift
//  WeatherForecast
//
//  Created by 오승기 on 2021/09/28.
//

import Foundation

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
    let main: String?
    let description: String?
    let icon: String?
}

struct Main: Decodable {
    let temp: Double
    let feelsLike: Double?
    let pressure: Int?
    let humidity: Int?
    let tempMin: Double?
    let tempMax: Double?
    let seaLevel: Int?
    let grndLevel: Int?
    let tempKF: Double?
    
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

struct Wind: Decodable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

struct Cloud: Decodable {
    let all: Int?
}

struct Rain: Decodable {
    let oneHour: Double?
    let threeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHour = "3h"
    }
}

struct Snow: Decodable {
    let oneHour: Double?
    let threeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHour = "3h"
    }
}
