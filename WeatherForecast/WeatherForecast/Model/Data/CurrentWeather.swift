//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/18.
//

import Foundation

struct CurrentWeather: Decodable {
    let addressName: String
    let temperature: Temperature
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case addressName = "name"
        case temperature = "main"
        case weather
    }
    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        addressName = try values.decode(String.self, forKey: .addressName)
//        temperature = try values.decode(Temperature.self, forKey: .temperature)
//        weather = try values.decode([Weather].self, forKey: .weather)
//    }
}
