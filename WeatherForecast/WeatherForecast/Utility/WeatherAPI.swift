//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by Yongwoo Marco on 2021/10/04.
//

import Foundation

enum WeatherAPI {
    
    private static var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "WeatherInfo", ofType: "plist") else {
            fatalError("Couldn't find file 'WeatherInfo.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "APIKey") as? String else {
            fatalError("Couldn't find key.")
        }
        return value
    }
    
    private static let scheme = "https"
    private static let host = "api.openweathermap.org"
    private static let appkey = WeatherAPI.apiKey
    
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
            return ["lat", "lon", "appid"]
        case .fiveday(.geographic):
            return ["lat", "lon", "appid"]
        case .fiveday(.cityName):
            return ["q", "appid"]
        }
    }
    
    private var values: [String] {
        var parameters: [String]
        switch self {
        case .current(.geographic(let latitude, let longitude)):
            parameters = ["\(latitude)", "\(longitude)"]
        case .fiveday(.geographic(let latitude, let longitude)):
            parameters = ["\(latitude)", "\(longitude)"]
        case .fiveday(.cityName(name: let name)):
            parameters = [name]
        }
        parameters.append(WeatherAPI.appid)
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
        return components.url
    }
}
