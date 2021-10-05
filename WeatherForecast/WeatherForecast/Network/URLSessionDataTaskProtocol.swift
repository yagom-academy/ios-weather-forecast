//
//  URLSessionDataTaskProtocol.swift
//  WeatherForecast
//
//  Created by Dasoll Park on 2021/10/01.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
