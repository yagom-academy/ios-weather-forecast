//
//  URLSession+dataTask.swift
//  WeatherForecast
//
//  Created by 임성민 on 2021/01/23.
//

import Foundation

extension URLSession {
    func dataTask(with request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        dataTask(with: request) { (data, response, error) in
            if let error = error {
                handler(.failure(error))
            } else {
                handler(.success(data ?? Data()))
            }
        }
    }
}
