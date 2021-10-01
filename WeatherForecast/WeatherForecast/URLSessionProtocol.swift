//
//  URLSessionProtocol.swift
//  WeatherForecast
//
//  Created by Dasoll Park on 2021/10/01.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
