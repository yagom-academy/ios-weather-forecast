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

enum WeatherRequest: TargetType {
    case getCurrentWeather(latitude: Double, longitude: Double)
    case getFiveDayForecast(latitude: Double, longitude: Double)
    
    private var apiKey: String {
        return "1af72e89e05d364984fe32463122135f"
    }
    
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
        var urlComponents = URLComponents(string: self.baseURL)
        urlComponents?.path = self.path
        let lat = URLQueryItem(name: "lat", value: self.query.0.description)
        let lon = URLQueryItem(name: "lon", value: self.query.1.description)
        let appId = URLQueryItem(name: "appid", value: self.apiKey)
        urlComponents?.queryItems = [lat, lon, appId]
        guard let url = urlComponents?.url else {
            return nil
        }
        let urlRequest = URLRequest(url: url)
        return urlRequest
    }
}
