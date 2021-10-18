//
//  APIClient.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/09/28.
//

import Foundation

struct APIManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func requestAPI(resource: RequestGeneratable,
                    completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let request = resource.generateRequest() else {
            completion(.failure(APIError.invalidUrl))
            return
        }
        
        session.dataTask(with: request) { (data, response, error) in
            let result = session.obtainResponseData(
                data: data, response: response, error: error)
            switch result {
            case .failure(let error):
                completion(.failure(error))
                return
            case .success(let data):
                completion(.success(data))
            }
        }.resume()
    }
}
