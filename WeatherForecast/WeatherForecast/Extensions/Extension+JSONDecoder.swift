//
//  WeatherJSONDecoder.swift
//  WeatherForecast
//
//  Created by Marco, Soll on 2021/10/01.
//

import Foundation

extension JSONDecoder {

    convenience init(keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy) {
        self.init()
        self.keyDecodingStrategy = keyDecodingStrategy
    }
}
