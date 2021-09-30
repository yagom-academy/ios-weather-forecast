//
//  Request.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/09/30.
//

import Foundation

enum WeatherAPI {
    static let baseURL = "https://api.openweathermap.org/data/2.5/"

    case current
    case forecast

    var url: String {
        switch self {
        case .current:
           return Self.baseURL + "weather"
        case .forecast:
           return Self.baseURL + "forecast"
        }
    }
}

enum URLQuery: String {
    case lat
    case lon
    case appid
}

struct Request {
    static func createURL(API: WeatherAPI, queryItems: [URLQuery: String]) -> URL? {
        var componets = URLComponents(string: API.url)

        for (key, value) in queryItems {
            let queryItem = URLQueryItem(name: key.rawValue, value: value)
            componets?.queryItems?.append(queryItem)
        }

        return componets?.url
    }
}
