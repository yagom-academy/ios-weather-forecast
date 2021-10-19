//
//  JSONDecodable.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/09/28.
//

import Foundation

enum ParsingError: LocalizedError {
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "Decoding Error"
        }
    }
}

protocol JSONDecodable {
    func decodeJSON<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

class DecodingManager: JSONDecodable {
    func decodeJSON<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        guard let data = try? JSONDecoder().decode(T.self, from: data) else {
            throw ParsingError.decodingError
        }
        return data
    }
}
