//
//  JSONDecodable.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/09/28.
//

import Foundation

enum ParsingError: LocalizedError {
    case invalidFileName
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidFileName:
            return "Invalid File Name"
        case .decodingError:
            return "Decoding Error"
        }
    }
}

protocol JSONDecodable {}

extension JSONDecodable {
    func readLocalFile(for name: String) throws -> Data {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            throw ParsingError.invalidFileName
        }
        return data
    }
    
    func decodedJSON<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        guard let data = try? JSONDecoder().decode(T.self, from: data) else {
            throw ParsingError.decodingError
        }
        return data
    }
}
