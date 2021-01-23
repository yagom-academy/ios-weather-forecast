//
//  URLMaker.swift
//  WeatherForecast
//
//  Created by 강인희 on 2021/01/24.
//

import Foundation

struct URLMaker {
    private let myKey = "2ce6e0d6185aa981602d52eb6e89fa16"
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    private let temperatureUnit = "metric"
    
    func makeRequestURL(with keyword: String, searching geographicCoordinate: GeographicCoordinate) -> URL? {
        if let validateURL =  URL(string:"\(baseURL)/\(keyword)?lat=\(geographicCoordinate.latitude)&lon=\(geographicCoordinate.longitude)&units=\(temperatureUnit)&appid=\(myKey)") {
            return validateURL
        }
        return nil
    }
}
