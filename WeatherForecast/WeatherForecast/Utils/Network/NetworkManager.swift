//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 샬롯, 수박, 루얀 on 2021/09/30.
//

import Foundation

protocol URLSessionable {
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionable { }

struct NetworkManager {
    private let urlGenerator = URLGenerator()
    private let session: URLSessionable
    
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
    
    func request<Model: Decodable>(
        endpoint: APIEndPoint,
        parameters: [String: Any],
        completionHandler: @escaping (Result<Model, Error>) -> Void
    ) {
        guard let url = urlGenerator.work(
                endpoint: endpoint,
                parameters: parameters
        ) else {
            completionHandler(
                .failure(NetworkError.invalidURL)
            )
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                let unknownError = NetworkError.unknown(
                    description: error.localizedDescription
                )
                completionHandler(
                    .failure(unknownError)
                )
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(
                    .failure(NetworkError.invalidResponse)
                )
                return
            }
            
            switch response.statusCode {
            case 200..<300:
                handleSuccessStatusCode(data: data, completionHandler: completionHandler)
            default:
                handleFailureStatusCode(response: response, completionHandler: completionHandler)
            }
        }.resume()
    }
    
    private func handleSuccessStatusCode<Model: Decodable>(
        data: Data?,
        completionHandler: @escaping (Result<Model, Error>) -> Void
    ) {
        guard let data = data else {
            completionHandler(
                .failure(NetworkError.dataIsNil)
            )
            return
        }
        
        do {
            let model: Model = try Parser.decode(data)
            completionHandler(
                .success(model)
            )
        } catch {
            completionHandler(
                .failure(error)
            )
        }
    }
    
    private func handleFailureStatusCode<Model>(
        response: HTTPURLResponse,
        completionHandler: @escaping (Result<Model, Error>) -> Void
    ) {
        switch response.statusCode {
        case 400..<500:
            completionHandler(
                .failure(NetworkError.clientSide(description: response.debugDescription))
            )
        case 500..<600:
            completionHandler(
                .failure(NetworkError.serverSide(description: response.debugDescription))
            )
        default:
            completionHandler(
                .failure(NetworkError.unknown(description: response.debugDescription))
            )
        }
    }
}
