//
//  Coordinate.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/20.
//

import Foundation

struct Coordinate: Decodable {
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
