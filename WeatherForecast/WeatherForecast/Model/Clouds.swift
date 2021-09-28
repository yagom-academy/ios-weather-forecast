//
//  Clouds.swift
//  WeatherForecast
//
//  Created by JINHONG AN on 2021/09/28.
//

import Foundation

struct Clouds: Decodable {
    let cloudiness: Int
    
    enum CodingKeys: String, CodingKey {
        case cloudiness = "all"
    }
}
