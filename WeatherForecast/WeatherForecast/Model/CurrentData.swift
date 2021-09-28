//
//  CurrentData.swift
//  WeatherForecast
//
//  Created by Marco, Soll on 2021/09/28.
//

import Foundation

struct CurrentData: WeatherInformation {
    var weather: [Weather]?
    var main: MainInformation?
    var visibility: Int?
    var wind: Wind?
    var clouds: Clouds?
    var date: TimeInterval?
    var sys: Sys?
    var rain: Rain?
    var snow: Snow?
    
    let coordinate: Coordinate?
    let base: String?
    let timezone: Int?
    let cityID: Int?
    let cityName: String?
    let cod: Int?

    enum CodingKeys: String, CodingKey {
        case weather, main, visibility, wind, clouds, sys, rain, snow
        case base, timezone, cod
        case date = "dt"
        case coordinate = "coord"
        case cityID = "id"
        case cityName = "name"
    }
}
