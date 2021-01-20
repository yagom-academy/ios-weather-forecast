//
//  Sys.swift
//  WeatherForecast
//
//  Created by Zero DotOne on 2021/01/18.
//

import Foundation

struct Local: Codable {
    let country: String?
    let sunrise: Int?
    let sunset: Int?
    let partOfTheDay: String?
    
    enum CodingKeys: String, CodingKey {
        case country
        case sunrise
        case sunset
        case partOfTheDay = "pod"
    }
}
