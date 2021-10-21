//
//  FivedaysWeather.swift
//  WeatherForecast
//
//  Created by 호싱잉, 잼킹 on 2021/09/28.
//

import Foundation

struct FivedaysWeather: Decodable {
    let list: [Item]
    
    enum CodingKeys: String, CodingKey {
        case list
    }
    
    struct Item: Decodable {
        let timeOfData: Double
        let mainInfo: MainInfo
        let weather: [Weather]
        
        enum CodingKeys: String, CodingKey {
            case weather
            case timeOfData = "dt"
            case mainInfo = "main"
        }
    }
}
