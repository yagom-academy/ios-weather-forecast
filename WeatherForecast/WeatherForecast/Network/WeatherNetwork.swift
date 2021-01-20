//
//  WeatherNetwork.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/21.
//

import Foundation

class WeatherNetwork {
    static func loadData(from url: URL, completion: @escaping ((Result<Data?, WeatherForcastError>) -> Void)) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
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
