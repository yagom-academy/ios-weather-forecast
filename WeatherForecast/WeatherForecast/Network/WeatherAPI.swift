//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by Yongwoo Marco on 2021/10/04.
//

import Foundation

enum WeatherAPI {
    
    private static var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "WeatherInfo", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let apiKey = plist.object(forKey: "APIKey") as? String else {
            NSLog("Couldn't find file 'WeatherInfo.plist'.")
            return ""
        }
        
        return apiKey
    }
    
    private static let scheme = "https"
    private static let host = "api.openweathermap.org"
    private static let appID = WeatherAPI.apiKey
    private static let unitsOfMeasurement = "metric"
    
    case current(CurrentData)
    case fiveday(FiveDayData)
    
    enum CurrentData {
        case geographic(latitude: Double, longitude: Double)
    }
    
    enum FiveDayData {
        case geographic(latitude: Double, longitude: Double)
        case cityName(name: String)
    }
    
    private var path: String {
        switch self {
        case .current(_):
            return "/data/2.5/weather"
        case .fiveday(_):
            return "/data/2.5/forecast"
        }
    }
    
    private var keys: [String] {
        switch self {
        case .current(.geographic):
            return ["lat", "lon", "units", "appid"]
        case .fiveday(.geographic):
            return ["lat", "lon", "units", "appid"]
        case .fiveday(.cityName):
            return ["q", "units", "appid"]
        }
    }
    
    private var values: [String] {
        var parameters: [String]
        switch self {
        case .current(.geographic(let latitude, let longitude)):
            parameters = ["\(latitude)", "\(longitude)", WeatherAPI.unitsOfMeasurement]
        case .fiveday(.geographic(let latitude, let longitude)):
            parameters = ["\(latitude)", "\(longitude)", WeatherAPI.unitsOfMeasurement]
        case .fiveday(.cityName(name: let name)):
            parameters = [name, WeatherAPI.unitsOfMeasurement]
        }
        parameters.append(WeatherAPI.appID)
        return parameters
    }
    
    func makeURL() -> URL? {
        var components = URLComponents()
        components.scheme = WeatherAPI.scheme
        components.host = WeatherAPI.host
        components.path = path
        
        let queryDictionary = Dictionary(uniqueKeysWithValues: zip(self.keys, self.values))
        let queryItems = queryDictionary.map({ URLQueryItem(name: $0.key, value: $0.value) })
        
        components.queryItems = queryItems
        guard let url = components.url else {
            print(WeatherAPI.WeatherAPIError.invalidUrl.errorDescription)
            return nil
        }
        return url
    }
}

extension WeatherAPI {
    
    enum WeatherAPIError: LocalizedError {
        case invalidUrl
        
        var errorDescription: String {
            switch self {
            case .invalidUrl:
                return NSLocalizedString("URL이 올바르지 않습니다", comment: "")
            }
        }
    }
}
