//
//  JSONDecodable.swift
//  WeatherForecast
//
//  Created by 호싱잉, 잼킹 on 2021/09/28.
//

import Foundation

enum ParsingError: LocalizedError {
    case decodingError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "디코딩 할 수 없습니다"
        case .unknown:
            return "알 수 없는 에러입니다"
        }
    }
}

protocol JSONDecodable {
    func decodeJSON<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecodable {
    func decodeJSON<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        guard let result = try? decoder.decode(T.self, from: data) else {
            throw ParsingError.decodingError
        }
        return result
    }
}
