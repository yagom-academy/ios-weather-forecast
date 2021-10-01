//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by Kim Do hyung on 2021/10/01.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invaildURL
    
    var errorDescription: String {
        switch self {
        case .invaildURL:
            return "유효하지 않은 url 입니다."
        }
    }
}

struct NetworkManager {
    
    static func request<T: Decodable>(using api: WeatherAPIable,
                                      completionHandler: @escaping (Result<T, Error>) -> Void) {
        guard let url = api.url else {
            return completionHandler(.failure(NetworkError.invaildURL))
        }
        let urlRequest = generateURLRequest(by: url, with: api)
    }
    
    private static func generateURLRequest(by url: URL, with api: WeatherAPIable) -> URLRequest {
        return URLRequest(url: url)
    }
}
