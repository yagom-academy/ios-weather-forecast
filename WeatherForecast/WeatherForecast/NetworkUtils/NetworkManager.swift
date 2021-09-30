//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 김준건 on 2021/09/29.
//

import Foundation

struct NetworkManager {
    private var networkable: Networkable
    private let urlRequestBuilder = URLRequestBuilder()
    
    init(networkable: Networkable = NetworkModule()) {
        self.networkable = networkable
    }
    
    mutating func getWeather(parameters: [URLQueryItem],
                    route: Route,
                    completionHandler: @escaping (Result<Data, Error>) -> Void)
    {
        guard let urlRequest = urlRequestBuilder.buildRequest(route: route, with: parameters) else {
            completionHandler(.failure(NetworkError.invalidURL))
            return
        }
        networkable.runDataTask(request: urlRequest, completionHandler: completionHandler)
    }
}
