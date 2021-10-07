//
//  WeatherForecastRoute.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/09/30.
//

import Foundation

enum WeatherForecastRoute: Route {
    case current
    case fiveDay
    
    private static var apiKey: String? {
        guard let filePath = Bundle.main.path(forResource: APIKey.fileName,
                                              ofType: APIKey.fileExtension)
        else {
            return nil
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        
        guard let key = plist?.object(forKey: APIKey.fileName) as? String else {
            return nil
        }
        return key
    }
    
    var scheme: String {
        return "https"
    }
    
    var baseURL: String {
        return "//api.openweathermap.org"
    }
    
    var path: String {
        switch self {
        case .current:
            return "/data/2.5/weather"
        case .fiveDay:
            return "/data/2.5/forecast"
        }
    }
    
    static func createParameters(latitude: Int, longitude: Int) -> [URLQueryItem] {
        let latitudeQuery = URLQueryItem(name: "lat", value: latitude.description)
        let longitudeQuery = URLQueryItem(name: "lon", value: longitude.description)
        let apiKeyQuery = URLQueryItem(name: "appid", value: apiKey)
        
        return [latitudeQuery, longitudeQuery, apiKeyQuery]
    }
}
