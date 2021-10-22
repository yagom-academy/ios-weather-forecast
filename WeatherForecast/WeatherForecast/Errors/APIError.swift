//
//  APIError.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/04.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidUrl
    case invalidResponse
    case invalideData
    case unknown(description: String)
    case outOfRange(statusCode: Int)
    case serverMessage(message: String)
    case convertImageFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .invalideData:
            return "Invalid Data"
        case .invalidResponse:
            return "Invalid Response"
        case .unknown(let description):
            return "Api Unknown Error: \(description)"
        case .outOfRange(let statusCode):
            return "status: \(statusCode)"
        case .serverMessage(let message):
            return message
        case .convertImageFailed:
            return "Convert Image Failed"
        }
    }
}
