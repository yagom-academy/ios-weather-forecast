//
//  URLSessionProtocol.swift
//  WeatherForecast
//
//  Created by Dasoll Park on 2021/10/01.
//

import Foundation

protocol URLSessionProtocol {
    func makeCustomDataTask(with url: URL,
                            completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func makeCustomDataTask(with url: URL,
                            completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}
