//
//  CommonWeatherModel.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/09/28.
//

import Foundation

// MARK: - For CurrentWeather, FiveDaysWeather
struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Coord: Decodable {
    let lon: Double
    let lat: Double
}

struct Wind: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double
}

struct Clouds: Decodable {
    let all: Int
}

// MARK: - For CurrentWeather
struct MainWeatherInfo: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    let seaLevel: Int
    let grndLevel: Int
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

struct Sys: Decodable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}

// MARK: - For FiveDaysWeather
struct ListMainWeatherInfo: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    let seaLevel: Int
    let grndLevel: Int
    let tempKf: Double
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case tempKf = "temp_kf"
    }
}

struct ListSys: Decodable {
    let pod: String
}

struct List: Decodable {
    let dt: Int
    let main: ListMainWeatherInfo
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Int
    let sys: ListSys
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather,
             clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
    }
}

struct City: Decodable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}
