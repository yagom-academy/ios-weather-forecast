//
//  WeatherDataManger.swift
//  WeatherForecast
//
//  Created by 호싱잉, 잼킹 on 2021/09/28.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case emptyData
    case unknown
}

final class WeatherDataManager {
    static let shared = WeatherDataManager()
    private init() {}
    
}

extension WeatherDataManager: JSONDecodable {
    private func fetch<ParsingType: Codable>(urlString: String, completion: @escaping (Result<ParsingType, Error>) -> ()) {
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIError.invalidResponse))
                return
            }
      
            guard let data = data else {
                completion(.failure(APIError.emptyData))
                return
            }
            
            do {
                let data = try self.decodeJSON(ParsingType.self, from: data)
                completion(.success(data))
            } catch {
                debugPrint(error.localizedDescription)
                completion(.failure(error))
            }
        }.resume()
    }
}


