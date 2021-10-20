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
            return "Oops! Can't convert to Data type".localized()
        case .decodingError:
            return "Oops! Can't decode".localized()
        }
    }
}
