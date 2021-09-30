//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by kjs on 2021/09/30.
//

import Foundation

protocol URLSessionable {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionable { }

struct NetworkManager {
    private let session: URLSessionable

    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
}
