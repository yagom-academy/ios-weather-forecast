//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 오승기 on 2021/09/30.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }

typealias SessionResult = (Result<Data, Error>) -> ()

class NetworkManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request(url: URL, completion: @escaping SessionResult) {
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                return
            }
            guard let data = data else {
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
