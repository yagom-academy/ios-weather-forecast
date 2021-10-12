//
//  FiveDayWeatherData.swift
//  WeatherForecast
//
//  Created by Marco, Soll on 2021/09/28.
//

import Foundation

struct FiveDayWeatherData: Codable {
    let intervalWeathers: [IntervalWeatherData]?
    
    enum CodingKeys: String, CodingKey {
        case intervalWeathers = "list"
    }
}
