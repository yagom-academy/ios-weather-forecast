//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by kjs on 2021/09/30.
//

import Foundation

protocol URLSessionable {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionable { }

struct NetworkManager {
    private let session: URLSessionable

    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
    
    func request(endpoint: WeatherForecastAPI.EndPoint,
                 parameters: [String: Any],
                 completionHandler: @escaping  (Result<TodayWeatherInfo, Error>) -> Void) {
        var components = URLComponents(string: WeatherForecastAPI.baseURL + endpoint.description)
        var queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
        }
        components?.queryItems = queryItems
        guard let url = components?.url else {
            completionHandler(.failure(NetworkError.invalidURL))
            return
        }
        session.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(NetworkError.invalidResponse))
                return
            }
//            switch response.statusCode {
//            case 200..<300:
//            default:
//            }
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            if let data = data {
                do {
                    
                } catch {
                    
                }
            }
        }
    }
}
