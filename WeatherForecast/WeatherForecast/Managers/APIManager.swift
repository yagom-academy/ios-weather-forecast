//
//  APIClient.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/09/28.
//

import Foundation
import UIKit

class APIManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func requestAPI(resource: RequestGeneratable,
                    completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let request = resource.generateRequest() else {
            completion(.failure(APIError.invalidUrl))
            return
        }
        
        session.dataTask(with: request) { (data, response, error) in
            if let networkError = APIError(data: data, response: response, error: error) {
                completion(.failure(networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.invalideData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    func downloadImage(resource: RequestGeneratable,
                              completion: @escaping (UIImage) -> Void) -> URLSessionDataTask? {
        guard let request = resource.generateRequest() else {
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, resopnce, error) in
            guard error == nil else {
                return
            }
            
            if let imageData = data,
               let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
        task.resume()
        return task
    }
}
