//
//  City.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/20.
//

import Foundation

struct City: Decodable {
    let id: Int
    let name: String
    let coordinate: Coordinate
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case coordinate = "coord"
    }
}
