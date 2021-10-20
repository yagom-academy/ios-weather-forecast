//
//  NetworkError.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/09/29.
//

import Foundation

enum NetworkError: LocalizedError {
    case badResponse
    case invalidData
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .badResponse:
            return "Oops! This is not a valid HTTP Response".localized()
        case .invalidData:
            return "Oops! Couldn't get data".localized()
        case .invalidURL:
            return "Oops! This is not a valid URL".localized()
        }
    }
}
