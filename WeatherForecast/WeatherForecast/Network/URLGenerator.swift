//
//  URLGenerator.swift
//  WeatherForecast
//
//  Created by 샬롯, 수박, 루얀 on 2021/10/05.
//

import Foundation

enum URLGenerator {

    static func work(with path: String, parameters: [String: Any]? = nil) -> URL? {
        var components = URLComponents(string: path)
        
        if let parameters = parameters {
            var queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
            }
            
            queryItems.append(
                URLQueryItem(
                    name: EndPoint.apiKey.name,
                    value: EndPoint.apiKey.value
                )
            )
            components?.queryItems = queryItems
        }
        
        return components?.url
    }
}
