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
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .requestFail:
            return "요청이 실패했습니다."
        case .failedStatusCode:
            return "실패 상태 코드가 전달되었습니다."
        case .emptyData:
            return "데이터가 존재하지 않습니다."
        case .invalidURL:
            return "잘못된 URL입니다."
        }
    }
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }

typealias SessionResult = (Result<Data, NetworkError>) -> ()

class NetworkManager<T: TargetType> {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request(_ request: TargetType, completion: @escaping SessionResult) {
        guard let urlRequest = request.configure() else {
            completion(.failure(.invalidURL))
            return
        }
        let task = session.dataTask(with: urlRequest) { data, response, error in
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
