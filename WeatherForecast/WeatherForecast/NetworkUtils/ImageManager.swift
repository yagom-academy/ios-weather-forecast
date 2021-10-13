//
//  ImageManager.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/10/13.
//

import Foundation
import UIKit.UIImage

struct ImageManager: MediaNetworkable {
    private let rangeOfSuccessState = 200...299
    private let customURLSession: URLSession = {
        URLCache.shared.memoryCapacity = 512 * 1024 * 1024
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: config)
    }()
    
    func loadImage(with urlPath: String,
                   completionHandler: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDataTask?
    {
        guard let url = URL(string: urlPath) else {
            completionHandler(.failure(NetworkError.invalidURL))
            return nil
        }
        
        let dataTask = customURLSession.dataTask(with: url) { [self] (data, response, error) in
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
            
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkError.invalidData))
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(.success(image))
            }
        }
        dataTask.resume()
        return dataTask
    }
}
