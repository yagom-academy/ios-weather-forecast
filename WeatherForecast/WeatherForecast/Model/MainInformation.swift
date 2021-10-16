//
//  MainInformation.swift
//  WeatherForecast
//
//  Created by Yongwoo Marco on 2021/10/16.
//

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
