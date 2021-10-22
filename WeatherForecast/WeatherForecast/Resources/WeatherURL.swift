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
    
    var method: Method {
        return .get
    }
    var parameter: [String: Any]? {
        switch self {
        case .weatherCoordinates(let latitude, let longitude):
            return ["lat": String(latitude),
                    "lon": String(longitude),
                    "appid": WeatherConfig.appKey]
            
        case .forecastCoordinates(let latitude, let longitude):
            return ["lat": String(latitude),
                    "lon": String(longitude),
                    "appid": WeatherConfig.appKey]
        }
    }
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
        return URL(string: weatherBaseURL)
    }
}
