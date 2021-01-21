//
//  Coordinate.swift
//  WeatherForecast
//
//  Created by 임성민 on 2021/01/21.
//

import Foundation

struct Coordinate: Decodable {
    let longitude: Double
    let latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}
