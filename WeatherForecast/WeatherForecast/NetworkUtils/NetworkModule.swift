//
//  NetworkModule.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/10/01.
//

import Foundation

struct NetworkModule: Networkable {
    private let rangeOfSuccessState = 200...299
    private var dataTask: [URLSessionDataTask] = []
    
    mutating func runDataTask(request: URLRequest,
                              completionHandler: @escaping (Result<Data, Error>) -> Void) {
        dataTask.enumerated().forEach { (index, task) in
            if let originalRequest = task.originalRequest,
               originalRequest == request {
                task.cancel()
                dataTask.remove(at: index)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  rangeOfSuccessState.contains(response.statusCode) else {
                      DispatchQueue.main.async {
                          completionHandler(.failure(NetworkError.badResponse))
                      }
                      return
                  }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkError.invalidData))
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(.success(data))
            }
        }
        task.resume()
        dataTask.append(task)
    }
}
