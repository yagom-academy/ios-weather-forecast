//
//  CityForAccess.swift
//  WeatherForecast
//
//  Created by iluxsm on 2021/01/19.
//

import Foundation

struct CityInformation: Decodable {
    let coord: Coordinates

    enum CordingKeys: String, CodingKey {
        case coord = "coord"
    }
}
