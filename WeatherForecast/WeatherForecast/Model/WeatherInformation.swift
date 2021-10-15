//
//  WeatherInformation.swift
//  WeatherForecast
//
//  Created by Marco, Soll on 2021/09/28.
//

import Foundation

protocol WeatherInformation: Codable {
    var conditions: [Condition] { get }
    var mainInformation: MainInformation { get }
}

struct Condition: Codable {
    let iconName: String
    
    private enum CodingKeys: String, CodingKey {
        case iconName = "icon"
    }
}

struct MainInformation: Codable {
    let temperature: Double
    let minimumTemperature: Double
    let maximumTemperature: Double
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case minimumTemperature = "tempMin"
        case maximumTemperature = "tempMax"
    }
}
