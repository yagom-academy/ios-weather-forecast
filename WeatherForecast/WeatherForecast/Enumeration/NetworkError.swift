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
            return "정상적인 HTTP Response가 아닙니다."
        case .invalidData:
            return "데이터를 받아오지 못했습니다."
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        }
    }
}
