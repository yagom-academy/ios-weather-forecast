//
//  Rain.swift
//  WeatherForecast
//
//  Created by JINHONG AN on 2021/09/28.
//

import Foundation

struct Rain: Decodable {
    let lastThreeHoursVolume: Double?
    
    enum CodingKeys: String, CodingKey {
        case lastThreeHoursVolume = "3h"
    }
}
