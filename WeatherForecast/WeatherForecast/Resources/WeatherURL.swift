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
    static let iconURL = "https://openweathermap.org/img/w"
}

enum WeatherURL: UrlGeneratable {
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
        case .weatherIcon:
            return nil
        }
    }
    
    case weatherCoordinates(latitude: Double, longitude: Double)
    case forecastCoordinates(latitude: Double, longitude: Double)
    case weatherIcon(iconID: String)
    
    var weatherURI: String {
        switch self {
        case .weatherCoordinates:
            return "\(WeatherConfig.baseURL)/weather"
        case .forecastCoordinates:
            return "\(WeatherConfig.baseURL)/forecast"
        case .weatherIcon(let iconID):
            return "\(WeatherConfig.iconURL)/\(iconID).png"
        }
    }
    
    func generateURL() -> URL? {
        return URL(string: self.weatherURI)
    }
}
