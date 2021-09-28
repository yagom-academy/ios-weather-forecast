//
//  IntervalData.swift
//  WeatherForecast
//
//  Created by Marco, Soll on 2021/09/28.
//

import Foundation

struct IntervalData: WeatherInformation {
    var weather: [Weather]?
    var main: MainInformation?
    var visibility: Int?
    var wind: Wind?
    var clouds: Clouds?
    var date: TimeInterval?
    var sys: Sys?
    var rain: Rain?
    var snow: Snow?
        
    let pop: Double?
    let dateText: String?
    
    enum CodingKeys: String, CodingKey {
        case weather, main, visibility, wind, clouds, sys, rain, snow, pop
        case date = "dt"
        case dateText = "dt_txt"
    }
}
