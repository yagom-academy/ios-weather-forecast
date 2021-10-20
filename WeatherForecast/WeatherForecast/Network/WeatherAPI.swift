//
//  Request.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/09/30.
//

import Foundation

enum WeatherAPI: API {
    static let baseURL = "https://api.openweathermap.org/data/2.5/"
    static let imagebaseURL = "https://openweathermap.org/img/w/"

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
