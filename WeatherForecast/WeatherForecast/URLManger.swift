//
//  APIManger.swift
//  WeatherForecast
//
//  Created by 김태형 on 2021/01/22.
//

import Foundation

class URLManager {
    static let common = URLManager()
    private init() {}
    
    enum Mode {
        case currentWeather
        case forecastFiveDays
        
        var baseURL: String {
            let mainURL = "https://api.openweathermap.org/data/2.5"
            switch self {
            case .currentWeather:
                return "\(mainURL)/weather?"
            default:
                return "\(mainURL)/forecast?"
            }
        }
    }
    
    func MakeURL(mode: Mode, latitude: Double, lontitude: Double) -> URL? {
        let units = URLQueryItem(name: "units", value: "metric")
        let myKey = URLQueryItem(name: "appid", value: "bdc8daed0ec51c18dfc0d8b9c84bb17c")
        let latitude = URLQueryItem(name: "lat", value: String(latitude))
        let lontitude = URLQueryItem(name: "lon", value: String(lontitude))
        
        guard var finalURL = URLComponents(string: mode.baseURL) else {
            return nil
        }
        finalURL.queryItems = [latitude, lontitude, myKey, units]
        
        return finalURL.url
    }
}
