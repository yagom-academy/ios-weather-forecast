//
//  Condition.swift
//  WeatherForecast
//
//  Created by Yongwoo Marco on 2021/10/16.
//

struct Condition: Codable {
    let iconName: String
    
    private enum CodingKeys: String, CodingKey {
        case iconName = "icon"
    }
}
