//
//  Config.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/19.
//

import Foundation

enum Config {
    static let weatherBaseURL = "https://api.openweathermap.org/data/2.5/"
    static let units = "units=metric"
    static let apiKey = "f69d4e7052b5e2f0dd63a6da187d02f5"
    static let queryFormat = "lat=%f&lon=%f&%@&appid=%@"
    static let querySeperator = "?"
    
    static func currentWeatherURL(lat: Double, lon: Double) -> String {
        var urlString = ""
        urlString.append(weatherBaseURL)
        urlString.append(WeatherAPI.current.rawValue)
        urlString.append(querySeperator)
        urlString.append(queryFormat)
        
        let url = String(format: urlString, lat, lon, units, apiKey)
        return url
    }
    
    static func forcastWeatherURL(lat: Double, lon: Double) -> String {
        var urlString = ""
        urlString.append(weatherBaseURL)
        urlString.append(WeatherAPI.forecast.rawValue)
        urlString.append(querySeperator)
        urlString.append(queryFormat)
        
        let url = String(format: urlString, lat, lon, units, apiKey)
        return url
    }
}
