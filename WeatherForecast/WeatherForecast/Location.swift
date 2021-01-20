//
//  City.swift
//  WeatherForecast
//
//  Created by 이학주 on 2021/01/19.
//

import Foundation

struct Location: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}
