//
//  Coordinate.swift
//  WeatherForecast
//
//  Created by JINHONG AN on 2021/09/28.
//

import Foundation

struct Coordinate: Decodable {
    let latitute: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitute = "lat"
        case longitude = "lon"
    }
}
