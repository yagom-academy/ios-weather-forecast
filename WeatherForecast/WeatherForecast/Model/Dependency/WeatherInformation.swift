//
//  WeatherInformation.swift
//  WeatherForecast
//
//  Created by Marco, Soll on 2021/09/28.
//

protocol WeatherInformation: Codable {
    var conditions: [Condition] { get }
    var mainInformation: MainInformation { get }
}
