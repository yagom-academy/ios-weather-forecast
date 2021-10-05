//
//  Parser.swift
//  WeatherForecast
//
//  Created by 샬롯, 수박, 루얀 on 2021/10/01.
//

import Foundation

struct Parser {
    let decoder = JSONDecoder()

    func decode<T: Codable>(_ data: Data, to model: T.Type) throws -> T {
        do {
            let parsedData = try decoder.decode(model, from: data)
            return parsedData
        } catch DecodingError.dataCorrupted(let context) {
            throw DecodingError.dataCorrupted(context)
        } catch DecodingError.keyNotFound(let codingKey, let context) {
            throw DecodingError.keyNotFound(codingKey, context)
        } catch DecodingError.typeMismatch(let type, let context) {
            throw DecodingError.typeMismatch(type, context)
        } catch DecodingError.valueNotFound(let value, let context) {
            throw DecodingError.valueNotFound(value, context) 
        }
    }
}
