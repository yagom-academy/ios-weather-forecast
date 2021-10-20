//
//  ImageManager.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/18.
//

import UIKit

enum ImageURL {
    case weather(String)
    
    var path: String {
        switch self {
        case .weather(let id):
            return "https://openweathermap.org/img/w/\(id).png"
        }
    }
}

struct ImageManager {
    private let cache = URLCache.shared
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
        cache.memoryCapacity = 500 * 1024 * 1024
    }
    
    @discardableResult
    func fetchImage(
        url: String,
        completion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionTask? {
            
            guard let url = URL(string: url) else {
                completion(.failure(APIError.invalidUrl))
                return nil
            }
            
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
            
            if let response = cache.cachedResponse(for: request),
               let imageData = UIImage(data: response.data) {
                completion(.success(imageData))
                return nil
                
            } else {
                let dataTask = session.dataTask(with: request) { data, response, error in
                    if let convertResponse = response, let convertData = data {
                        self.cache.storeCachedResponse(
                            CachedURLResponse(
                                response: convertResponse, data: convertData), for: request)
                    }
                    let result = session.obtainResponseData(
                        data: data, response: response, error: error)
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                        return
                    case .success(let data):
                        guard let imageData = UIImage(data: data) else {
                            completion(.failure(APIError.convertImageFailed))
                            ErrorHandler(
                                error: APIError.convertImageFailed).printErrorDescription()
                            return
                        }
                        completion(.success(imageData))
                    }
                }
                dataTask.resume()
                return dataTask
            }
        }
}
