//
//  CityForAccess.swift
//  WeatherForecast
//
//  Created by iluxsm on 2021/01/19.
//

import Foundation

struct CityForAccess: Decodable {
    let coordinates: Coordinates

    enum CordingKeys: String, CodingKey {
        case coordinates = "coord"
    }
}
