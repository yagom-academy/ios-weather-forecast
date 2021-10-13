//
//  Request.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/09/30.
//

import Foundation

enum WeatherAPI: API {
    private static let baseURL = "https://api.openweathermap.org"
    private static let weatherPath = "/data/2.5/"
    private static let iconPath = "/img/w/"
    
    case current
    case forecast
    case icon
    
    var url: String {
        switch self {
        case .current:
            return Self.baseURL + Self.weatherPath + "weather"
        case .forecast:
            return Self.baseURL + Self.weatherPath + "forecast"
        case .icon:
            return Self.baseURL + Self.iconPath
        }
    }
}

enum CoordinatesQuery: Query {
    case lat
    case lon
    case appid
    case units
    
    var description: String {
        switch self {
        case .lat:
            return "lat"
        case .lon:
            return "lon"
        case .appid:
            return "appid"
        case .units:
            return "units"
        }
    }
}
