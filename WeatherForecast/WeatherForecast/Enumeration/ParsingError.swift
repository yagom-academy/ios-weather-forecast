//
//  ParsingError.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/09/28.
//

import Foundation

enum ParsingError: LocalizedError {
    case dataConvertError
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .dataConvertError:
            return "Data 타입으로 변환 중 문제가 발생하였습니다."
        case .decodingError:
            return "디코딩을 하는 도중 문제가 발생하였습니다."
        }
    }
}
