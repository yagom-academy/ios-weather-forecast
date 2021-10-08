//
//  URL.swift
//  WeatherForecast
//
//  Created by 이윤주 on 2021/09/29.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol TargetType {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var query: (Double, Double) { get }
    
    func configure() -> URLRequest?
}

enum WeatherRequest: TargetType {
    case getCurrentWeather(latitude: Double, longitude: Double)
    case getFiveDayForecast(latitude: Double, longitude: Double)
    
    var baseURL: String {
        return "https://api.openweathermap.org"
    }
    
    var path: String {
        switch self {
        case .getCurrentWeather:
            return "/data/2.5/weather"
        case .getFiveDayForecast:
            return "/data/2.5/forecast"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var query: (Double, Double) {
        switch self {
        case .getCurrentWeather(latitude: let latitude, longitude: let longitude):
            return (latitude, longitude)
        case .getFiveDayForecast(latitude: let latitude, longitude: let longitude):
            return (latitude, longitude)
        }
    }
    
    func configure() -> URLRequest? {
        <#code#>
    }
}

//enum URLAPI {
//    case getCurrent
//    case getForecast
//
//    var path: String {
//        switch self {
//        case .getCurrent:
//            return "/data/2.5/weather"
//        case .getForecast:
//            return "/data/2.5/forecast"
//        }
//    }
//}
//
//extension URLAPI {
//    func configure(urlAPI: URLAPI, latitude: Double, longitude: Double) -> URL? {
//        let apiKey = "1af72e89e05d364984fe32463122135f"
//        var urlComponents = URLComponents()
//        urlComponents.scheme = "https"
//        urlComponents.host = "api.openweathermap.org"
//        urlComponents.path = urlAPI.path
//        let lat = URLQueryItem(name: "lat", value: latitude.description)
//        let lon = URLQueryItem(name: "lon", value: longitude.description)
//        let appId = URLQueryItem(name: "appid", value: apiKey)
//        urlComponents.queryItems = [lat, lon, appId]
//
//        return urlComponents.url
//    }
//}
