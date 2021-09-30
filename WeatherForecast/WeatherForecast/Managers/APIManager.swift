//
//  APIClient.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/09/28.
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

class APIManager {
    static func requestAPI<T, S>(_ responseType: T.Type,
                          _ errorType: S.Type,
                          resource: APIResource,
                          decodeManager: JSONDecodable,
                          completion: @escaping (Result<T, Error>) -> Void
    ) where T: Decodable, S: Decodable & ErrorMessageProtocol {
        let successRange = 200...299
        
        guard let request = resource.generateRequest() else {
            completion(.failure(APIError.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                guard error == nil else {
                    completion(.failure(APIError.dataTask))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(APIError.invalidResponse))
                    return
                }
                
                guard successRange.contains(httpResponse.statusCode) else {
                    if let data = data {
                        let parsedError = try decodeManager.decodeJSON(S.self, from: data)
                        completion(.failure(APIError.serverMessage(message: (parsedError as ErrorMessageProtocol).errorMessage)))
                        return
                    }
                    
                    completion(.failure(APIError.outOfRange(statusCode: httpResponse.statusCode)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(APIError.invalideData))
                    return
                }
                
                let parsedData = try decodeManager.decodeJSON(T.self, from: data)
                completion(.success(parsedData))
            } catch let parsingError as ParsingError {
                completion(.failure(parsingError))
            } catch {
                completion(.failure(APIError.unknown))
            }
        }.resume()
    }
}
