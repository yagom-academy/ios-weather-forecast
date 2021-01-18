//
//  CityInformation.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/18.
//

import Foundation

struct CityInformation: Codable {
    let addressName: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "name"
    }
}
