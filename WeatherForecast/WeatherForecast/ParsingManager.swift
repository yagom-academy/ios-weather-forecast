//
//  ParsingManager.swift
//  WeatherForecast
//
//  Created by 이윤주 on 2021/09/28.
//

import Foundation

struct ParsingManager {
    enum ParsingError: Error, LocalizedError {
        case decodingFailed
        
        var errorDescription: String? {
            switch self {
            case .decodingFailed:
                return "decoding에 실패하였습니다!!!"
            }
        }
    }

    private let decoder = JSONDecoder()

    func parse<T: Decodable>(_ data: Data, to model: T.Type) -> Result<T, ParsingError> {
        let parsedData = try? decoder.decode(model, from: data)
        guard let jsonData = parsedData else {
            return .failure(.decodingFailed)
        }
        return .success(jsonData)
    }
}
