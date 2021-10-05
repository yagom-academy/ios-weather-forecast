//
//  Wind.swift
//  WeatherForecast
//
//  Created by Kim Do hyung on 2021/09/28.
//

import Foundation

struct Wind: Decodable {
    let speed: Double?
    let degree: Int?
    let gust: Double?
    
    enum CodingKeys: String, CodingKey {
        case speed, gust
        case degree = "deg"
    }
}
