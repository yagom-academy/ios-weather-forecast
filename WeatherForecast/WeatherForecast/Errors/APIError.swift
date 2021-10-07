//
//  APIError.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/04.
//

import Foundation

enum APIError: LocalizedError {
    case invalidUrl
    case dataTask
    case invalidResponse
    case invalideData
    case unknown
    case outOfRange(statusCode: Int)
    case serverMessage(message: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .invalideData:
            return "Invalid Data"
        case .dataTask:
            return "DataTask Error"
        case .invalidResponse:
            return "Invalid Response"
        case .unknown:
            return "Api Unknown Error"
        case .outOfRange(let statusCode):
            return "status: \(statusCode)"
        case .serverMessage(let message):
            return message
        }
    }
}

extension APIError {
    init?(data: Data?, response: URLResponse?, error: Error?) {
        let successRange = 200...299
        guard error == nil else {
            self = .dataTask
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            self = .invalidResponse
            return
        }
        
        guard successRange.contains(httpResponse.statusCode) else {
            self = .outOfRange(statusCode: httpResponse.statusCode)
            return
        }
        
        return nil
    }
}
