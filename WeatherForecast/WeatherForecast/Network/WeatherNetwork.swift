//
//  WeatherNetwork.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/21.
//

import Foundation

class WeatherNetwork {
    static func loadData<T: Decodable>(from url: URL, with dataType: T.Type, completion: @escaping ((Result<T?, WeatherForcastError>) -> Void)) {
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
            guard let rawData = data else {
                return completion(.failure(.getData))
            }
            do {
                let data = try JSONDecoder().decode(dataType, from: rawData)
                return completion(.success(data))
            } catch {
                return completion(.failure(.convertWeatherData))
            }
        }.resume()
    }
}
