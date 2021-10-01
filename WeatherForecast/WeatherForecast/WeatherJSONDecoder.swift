//
//  WeatherJSONDecoder.swift
//  WeatherForecast
//
//  Created by Dasoll Park on 2021/10/01.
//

import Foundation

class WeatherJSONDecoder: JSONDecoder {
    
    override init() {
        super.init()
        self.keyDecodingStrategy = .convertFromSnakeCase
    }
}
