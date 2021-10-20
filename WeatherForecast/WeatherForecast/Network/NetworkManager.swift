//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 샬롯, 수박, 루얀 on 2021/09/30.
//

import Foundation
import UIKit

protocol URLSessionable {
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionable { }

struct NetworkManager {
    static let shared = NetworkManager()
    private let parser = Parser()
    private let session: URLSessionable
    
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
    
    func request<Model: Decodable>(
        with url: URL,
        completionHandler: @escaping (Result<Model, Error>) -> Void
    ) {
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

    func requestImage(
        with url: URL,
        completionHandler: @escaping (Result<Data, Error>) -> Void
    ) {
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
            let model: Model = try parser.decode(data)
            completionHandler(
                .success(model)
            )
        } catch {
            completionHandler(
                .failure(error)
            )
        }
    }

    private func handleSuccessStatusCode(
        data: Data?,
        completionHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let data = data else {
            completionHandler(
                .failure(NetworkError.dataIsNil)
            )
            return
        }

        completionHandler(.success(data))
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
