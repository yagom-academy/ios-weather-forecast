//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 박태현 on 2021/09/30.
//

import Foundation

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
}

class NetworkManager {
    private let session: URLSession
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func dataTask(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.invalidRequest))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
}
