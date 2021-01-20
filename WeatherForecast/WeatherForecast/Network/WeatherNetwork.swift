//
//  WeatherNetwork.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/21.
//

import Foundation

class WeatherNetwork {
    static let shared = WeatherNetwork()
    private init() {}
    
    func loadData(from url: URL, completion: @escaping ((Result<Data?, WeatherForcastError>) -> Void)) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.network))
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(.network))
            }
            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
}
