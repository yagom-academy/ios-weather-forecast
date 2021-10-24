//
//  ParsingError.swift
//  WeatherForecast
//
//  Created by 이윤주 on 2021/10/09.
//

import Foundation

enum ParsingError: Error, LocalizedError {
    case decodingFailed
    
    var errorDescription: String? {
        switch self {
        case .decodingFailed:
            return "decoding에 실패하였습니다!!!"
        }
    }
}
