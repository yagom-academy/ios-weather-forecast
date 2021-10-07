//
//  WeatherURL.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/09/30.
//

import Foundation

enum WeatherConfig {
    static let appKey = "5b0c9717f130cf0eb03095b31fe5417e"
    static let baseURL = "https://api.openweathermap.org/data/2.5"
}

enum WeatherURL: UrlGeneratable {
    case weatherCoordinates(latitude: Double, longitude: Double)
    case forecastCoordinates(latitude: Double, longitude: Double)
    
    private var weatherURI: String {
        switch self {
        case .weatherCoordinates:
            return "/weather"
        case .forecastCoordinates:
            return "/forecast"
        }
    }
    
    func generateURL() -> URL? {
        let weatherBaseURL = "\(WeatherConfig.baseURL)\(self.weatherURI)"
        var components = URLComponents(string: weatherBaseURL)
        switch self {
        case .weatherCoordinates(let latitude, let longitude):
            let latitude = URLQueryItem(name: "lat", value: String(latitude))
            let longitude = URLQueryItem(name: "lon", value: String(longitude))
            let appID = URLQueryItem(name: "appid", value: WeatherConfig.appKey)
            components?.queryItems = [latitude, longitude, appID]
            return components?.url
            
        case .forecastCoordinates(let latitude, let longitude):
            let latitude = URLQueryItem(name: "lat", value: String(latitude))
            let longitude = URLQueryItem(name: "lon", value: String(longitude))
            let appId = URLQueryItem(name: "appid", value: WeatherConfig.appKey)
            components?.queryItems = [latitude, longitude, appId]
            return components?.url
        }
    }
}
