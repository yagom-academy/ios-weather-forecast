//
//  MainWeatherInformation.swift
//  WeatherForecast
//
//  Created by JINHONG AN on 2021/09/28.
//

import Foundation

struct MainWeatherInformation: Decodable {
    let temperature: Double?
    let windChill: Double?
    let minimumTemperature: Double?
    let maximumTemperature: Double?
    let pressure: Int?
    let humidity: Int?
    let seaLevelPressure: Int?
    let groundLevelPressure: Int?
    let freezingPoint: Double?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case windChill = "feels_like"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
        case pressure, humidity
        case seaLevelPressure = "sea_level"
        case groundLevelPressure = "grnd_level"
        case freezingPoint = "temp_kf"
    }
}
