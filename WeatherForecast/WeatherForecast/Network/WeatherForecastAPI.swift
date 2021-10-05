//
//  WeatherForecastAPI.swift
//  WeatherForecast
//
//  Created by 샬롯, 수박, 루얀 on 2021/09/30.
//
import Foundation

enum APIEndPoint {
    private static let baseURL = "api.openweathermap.org/data/2.5/"
    // TODO: 저장 위치
    static let APIKey = "a529112a5512a01db04290ddf7b83639"
    
    case daily
    case weekly

    var path: String {
        switch self {
        case .daily:
            return APIEndPoint.baseURL + "weather"
        case .weekly:
            return APIEndPoint.baseURL + "forecast"
        }
    }
}
