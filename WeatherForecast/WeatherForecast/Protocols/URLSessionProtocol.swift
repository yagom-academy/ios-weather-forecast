//
//  URLSessionProtocol.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/04.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (
            Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

extension URLSessionProtocol {
    func obtainResponseData(
        data: Data?,
        response: URLResponse?,
        error: Error?) -> Result<Data, Error> {
        let successRange = 200...299
        if let error = error {
            return .failure(APIError.unknown(description: error.localizedDescription))
        }
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(APIError.invalidResponse)
            }
            guard successRange.contains(httpResponse.statusCode) else {
                return .failure(APIError.outOfRange(statusCode: httpResponse.statusCode))
        }
            guard let data = data else {
                return .failure(APIError.invalideData)
            }
        return .success(data)
    }
}
