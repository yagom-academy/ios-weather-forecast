//
//  System.swift
//  WeatherForecast
//
//  Created by Kim Do hyung on 2021/09/28.
//

import Foundation

struct System: Decodable {
    let type: Int?
    let id: Int?
    let message: Double?
    let country: String?
    let sunriseTime: TimeInterval?
    let sunsetTime: TimeInterval?
    let partOfTheDay: String?
    
    enum CodingKeys: String, CodingKey {
        case type, id, country, message
        case sunriseTime = "sunrise"
        case sunsetTime = "sunset"
        case partOfTheDay = "pod"
    }
}
