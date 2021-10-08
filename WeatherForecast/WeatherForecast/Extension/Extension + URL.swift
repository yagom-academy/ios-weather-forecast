//
//  Extension + URL.swift
//  WeatherForecast
//
//  Created by 박태현 on 2021/10/04.
//

import Foundation

extension URL {
    static func createURL<T: Query>(API: API, queryItems: [T: String]) -> URL? {
        var componets = URLComponents(string: API.url)
        var queryArray: [URLQueryItem] = []
        for (key, value) in queryItems {
            let queryItem = URLQueryItem(name: key.description, value: value)
            queryArray.append(queryItem)
        }
        componets?.queryItems = queryArray
        return componets?.url
    }
}
