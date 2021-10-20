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
    private var session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        URLCache.shared.memoryCapacity = 500 * 1024 * 1024
        self.session = URLSession(configuration: configuration)
    }
    
    func fetchImage(
        url: String,
        completion: @escaping (Result<UIImage, Error>) -> Void) {
            
            guard let url = URL(string: url) else {
                completion(.failure(APIError.invalidUrl))
                return
            }
            let request = URLRequest(url: url)
            
            session.dataTask(with: request) { data, response, error in
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
            }.resume()
        }
}
