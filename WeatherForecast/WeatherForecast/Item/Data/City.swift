//
//  CityInformation.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/18.
//

import Foundation

struct City: Decodable {
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case address = "name"
    }
}
