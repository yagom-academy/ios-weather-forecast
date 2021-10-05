//
//  URLGenerator.swift
//  WeatherForecast
//
//  Created by 샬롯, 수박, 루얀 on 2021/10/05.
//

import Foundation

struct URLGenerator {
    func work(
        endpoint: APIEndPoint,
        parameters: [String: Any]
    ) -> URL? {
        var components = URLComponents(string: endpoint.path)
        var queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
        }
        components?.queryItems = queryItems
        return components?.url
    }
}
