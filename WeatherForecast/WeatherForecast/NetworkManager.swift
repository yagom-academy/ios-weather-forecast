//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 오승기 on 2021/09/30.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case requestFail
    case failedStatusCode
    case emptyData
    
    var errorDescription: String? {
        switch self {
        case .requestFail:
            return "요청이 실패했습니다."
        case .failedStatusCode:
            return "실패 상태 코드가 전달되었습니다."
        case .emptyData:
            return "데이터가 존재하지 않습니다."
        }
    }
}

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }

typealias SessionResult = (Result<Data, NetworkError>) -> ()

class NetworkManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request(url: URL, completion: @escaping SessionResult) {
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.requestFail))
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                completion(.failure(.failedStatusCode))
                return
            }
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
