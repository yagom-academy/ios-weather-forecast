//
//  WeatherNetworkManager.swift
//  WeatherForecast
//
//  Created by Marco, Soll on 2021/10/01.
//

import Foundation

struct WeatherNetworkManager {
    enum NetworkError: Error {
        case responseError
        case dataError
    }
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func requestData(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        session.makeCustomDataTask(with: url) { data, response, error in
            let successRange = 200..<300
            guard error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            guard let response = response as? HTTPURLResponse,
                  successRange ~= response.statusCode else {
                completion(.failure(NetworkError.responseError))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.dataError))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
