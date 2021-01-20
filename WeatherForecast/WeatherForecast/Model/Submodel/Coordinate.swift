//
//  Coordinate.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/20.
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
