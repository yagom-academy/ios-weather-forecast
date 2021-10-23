//
//  URLSessionProtocol.swift
//  WeatherForecast
//
//  Created by 이윤주 on 2021/10/09.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }
