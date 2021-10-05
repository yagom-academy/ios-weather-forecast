//
//  ParsingManager.swift
//  WeatherForecast
//
//  Created by JINHONG AN on 2021/10/01.
//

import Foundation

struct ParsingManager {
    static func decode<T: Decodable>(from data: Data, to modelType: T.Type) -> T? {
        let decoder = JSONDecoder()
        let model = try? decoder.decode(modelType, from: data)
        return model
    }
}
