//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by 호싱잉, 잼킹 on 2021/09/28.
//

import Foundation

struct CurrentWeather: Decodable {
    let weather: [Weather]
    let mainInfo: MainInfo
    
    enum CodingKeys: String, CodingKey {
        case weather
        case mainInfo = "main"
    }
}
