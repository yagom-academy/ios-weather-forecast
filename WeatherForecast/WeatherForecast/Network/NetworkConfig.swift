//
//  NetworkConfig.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/20.
//

import Foundation

struct NetworkConfig {
    private static let appId = "dfae32caf228b6ced799aaadfd1babec"
    private static let queryFormat = "lat=%f&lon=%f&appid=%@"
    private static let currentWeatherAPI = "https://api.openweathermap.org/data/2.5/weather?"
    private static let fiveDaysForecastAPI = "https://api.openweathermap.org/data/2.5/forecast?"
    
    static func makeWeatherUrlString(type: WeatherAPI, latitude: Double, longitude: Double) -> String {
        var urlString: String
        switch type {
        case .current:
            urlString = NetworkConfig.currentWeatherAPI
        case .fiveDaysForecast:
            urlString = NetworkConfig.fiveDaysForecastAPI
        }
        let queryString = String(format: NetworkConfig.queryFormat, latitude, longitude, NetworkConfig.appId)
        urlString.append(queryString)
        
        return urlString
    }
}
