//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 오승기 on 2021/09/30.
//

import Foundation

typealias SessionResult = (Result<Data, NetworkError>) -> ()

class NetworkManager<T: TargetType> {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request(_ request: T, completion: @escaping SessionResult) {
        guard let urlRequest = request.configure() else {
            completion(.failure(.invalidURL))
            return
        }
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(.requestFail))
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                      completion(.failure(.failedStatusCode))
                      return
                  }
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
