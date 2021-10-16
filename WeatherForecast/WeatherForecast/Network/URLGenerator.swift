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
        var components = URLComponents(string: endpoint.urlString)
        var queryItems = [URLQueryItem]()

        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
        }
        queryItems.append(
            URLQueryItem(
                name: APIEndPoint.APIKey.name,
                value: APIEndPoint.APIKey.value
            )
        )        
        components?.queryItems = queryItems

        return components?.url
    }

    func work(
        endpoint: ImageEndPoint
    ) -> URL? {
        let components = URLComponents(string: endpoint.urlString)

        return components?.url
    }
}
