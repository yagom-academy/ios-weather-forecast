//
//  Coordinate.swift
//  WeatherForecast
//
//  Created by 이예원 on 2021/09/28.
//

import Foundation

struct Coordinate: Codable {
    let longitude: Double
    let latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}
