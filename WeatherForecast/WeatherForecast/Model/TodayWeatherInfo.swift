//
//  TodayWeatherInfo.swift
//  WeatherForecast
//
//  Created by 샬롯, 수박, 루얀 on 2021/09/28.
//

import Foundation

struct TodayWeatherInfo: Codable {
    let coordinate: Coordinate?
    let weather: [WeatherExpression]?
    let main: WeatherNumericalValue?
    let visibility: Double?
    let wind: Wind?
    let clouds: Clouds?
    let calculatedTime: TimeInterval?
    
    enum CodingKeys: String, CodingKey {
        case weather, main, visibility, wind, clouds
        case coordinate = "coord"
        case calculatedTime = "dt"
    }
}
