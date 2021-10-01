//
//  Parser.swift
//  WeatherForecast
//
//  Created by kjs on 2021/10/01.
//

import Foundation

enum ParsingError: Error {
    case decodingFail
}

struct Parser {
    let decoder = JSONDecoder()

    func decode<T: Codable>(_ data: Data, to model: T.Type) throws -> T {
        do {
            let parsedData = try decoder.decode(model, from: data)
            return parsedData
        } catch {
            throw ParsingError.decodingFail
        }
    }
}
