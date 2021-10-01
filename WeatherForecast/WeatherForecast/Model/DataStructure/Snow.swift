//
//  Snow.swift
//  WeatherForecast
//
//  Created by Kim Do hyung on 2021/09/28.
//

import Foundation

struct Snow: Decodable {
    let lastThreeHoursVolume: Double?
    
    enum CodingKeys: String, CodingKey {
        case lastThreeHoursVolume = "3h"
    }
}
