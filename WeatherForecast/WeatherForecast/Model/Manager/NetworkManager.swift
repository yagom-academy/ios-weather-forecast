//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by Kim Do hyung on 2021/10/01.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invaildURL
    case failedResponse
    case notAvailableData
    
    var errorDescription: String {
        switch self {
        case .invaildURL:
            return "유효하지 않은 url 입니다."
        case .failedResponse:
            return "통신에 실패하였습니다."
        case .notAvailableData:
            return "데이터를 얻지 못했습니다."
        }
    }
}

struct NetworkManager {
    static let successCode = 200...299
    
    static func request(using api: APIable,
                        completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard let url = api.url else {
            return completionHandler(.failure(NetworkError.invaildURL))
        }
        
        let urlSession = URLSession.shared
        let urlRequest = generateURLRequest(by: url, with: api)
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                return completionHandler(.failure(error))
            }
            guard let response = response as? HTTPURLResponse, successCode ~= response.statusCode else {
                return completionHandler(.failure(NetworkError.failedResponse))
            }
            guard let data = data else {
                return completionHandler(.failure(NetworkError.notAvailableData))
            }
            completionHandler(.success(data))
        }.resume()
    }
    
    private static func generateURLRequest(by url: URL, with api: APIable) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.requestType.methodName
        return urlRequest
    }
}
