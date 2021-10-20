//
//  WeatherValues.swift
//  WeatherForecast
//
//  Created by 샬롯, 수박, 루얀 on 2021/10/05.
//

import Foundation

struct WeatherExpression: Codable {
    let identifier: Int?
    let main: String?
    let body: String?
    let icon: String?
    
    enum CodingKeys: String, CodingKey {
        case main, icon
        case identifier = "id"
        case body = "description"
    }
}

struct WeatherNumericalValue: Codable {
    let temperature: Double?
    let feelsLike: Double?
    let minimumTemperature: Double?
    let maximumTemperature: Double?
    let pressure: Int?
    let humidity: Int?

    enum CodingKeys: String, CodingKey {
        case pressure, humidity
        case temperature = "temp"
        case feelsLike = "feels_like"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
    }
}
