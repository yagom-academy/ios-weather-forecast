//
//  Config.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/19.
//

import Foundation

enum Config {
    static let weatherBaseURL = "https://api.openweathermap.org/data/2.5/"
    static let current = "weather?"
    static let forecast = "forecast?"
    static let lat = "lat=%f&"
    static let lon = "lon=%f&"
    static let units = "units=metric&"
    static let apiKey = "appid=f69d4e7052b5e2f0dd63a6da187d02f5"
    
    static func currentWeatherURL(lat: Double, lon: Double) -> String {
        let queryString = "\(Config.lat)\(Config.lon)\(Config.units)\(Config.apiKey)"
        let url = String(format: "\(Config.weatherBaseURL)\(Config.current)\(queryString)", lat, lon)
        return url
    }
    
    static func forcastWeatherURL(lat: Double, lon: Double) -> String {
        let queryString = "\(Config.lat)\(Config.lon)\(Config.units)\(Config.apiKey)"
        let url = String(format: "\(Config.weatherBaseURL)\(Config.forecast)\(queryString)", lat, lon)
        return url
    }
}
