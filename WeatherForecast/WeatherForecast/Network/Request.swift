//
//  Request.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/09/30.
//

import Foundation

enum WeatherAPI: API {
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

enum CoordinatesQuery: Query {
    case lat
    case lon
    case appid

    var description: String {
        switch self {
        case .lat:
            return "lat"
        case .lon:
            return "lon"
        case .appid:
            return "appid"
        }
    }
}

struct Request {
    static func createURL<T: Query>(API: API, queryItems: [T: String]) -> URL? {
        var componets = URLComponents(string: API.url)

        for (key, value) in queryItems {
            let queryItem = URLQueryItem(name: key.description, value: value)
            componets?.queryItems?.append(queryItem)
        }

        return componets?.url
    }
}

protocol API {
    var url: String { get }
}
protocol Query {
    var description: String { get }
}
