//
//  NetworkConfig.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/20.
//

import Foundation

struct NetworkConfig {
    private static let baseURL = "https://api.openweathermap.org/data/2.5/"
    private static let appId = "dfae32caf228b6ced799aaadfd1babec"
    private static let queryFormat = "lat=%f&lon=%f&appid=%@"
    private static let matrics = "&units=metric"
    
    static func makeWeatherUrlString(type: WeatherAPIKey, coordinate: Coordinate) -> String {
        var urlString = baseURL
        urlString.append(type.rawValue)
        urlString.append("?")
        
        let queryString = String(format: NetworkConfig.queryFormat, coordinate.latitude, coordinate.longitude, NetworkConfig.appId)
        urlString.append(queryString)
        urlString.append(matrics)
        
        return urlString
    }
}
