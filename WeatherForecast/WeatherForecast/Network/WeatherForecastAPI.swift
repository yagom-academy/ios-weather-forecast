//
//  WeatherForecastAPI.swift
//  WeatherForecast
//
//  Created by kjs on 2021/09/30.
//

import Foundation
// daily
// api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
//
// weekly
// api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API key}

// ???
// api.openweathermap.org/data/2.5/abcd?asd={asd}&bcd={bcd}....

enum WeatherForecastAPI {
    static let baseURL = "api.openweathermap.org/data/2.5/"
    static let APIKey = "a529112a5512a01db04290ddf7b83639"

    enum EndPoint: CustomStringConvertible {
        case daily
        case weekly

        var description: String {
            switch self {
            case .daily:
                return "weather"
            case .weekly:
                return "forecast"
            }
        }
    }

    enum Parameters {
        case coordinate(coord: Coordinate)
    }

    case getWeather(endPoint: EndPoint, params: Parameters)
    var urlComponents: URL {
        var component: URLComponents?
        switch self {
        case .getWeather(let endPoint, let params):
            component = URLComponents(string: Self.baseURL + String(describing: endPoint))

            switch params {
            case .coordinate(let coord):
                let latitude = URLQueryItem(name: "lat", value: "\(coord.latitude)")
                let longitude = URLQueryItem(name: "lon", value: "\(coord.longitude)")
                component?.queryItems = [latitude, longitude]
            }
            component?.queryItems?.append(URLQueryItem(name: "appid", value: Self.APIKey))
        }
        guard let url = component?.url else {
            fatalError()
        }
        return url
    }
//    case getDailyWeather(coord: Coordinate)
//    case getWeeklyWeather(coord: Coordinate)
//
//    var urlComponents: String {
//        var components: URLComponents? // = URLComponents(string: Self.baseURL)
//        let latitude = URLQueryItem(name: "lat", value: "{lat}")
//        let longitude = URLQueryItem(name: "lon", value: "{lon}")
//        switch self {
//        case .getDailyWeather(let coord):
//            components = URLComponents(string: Self.baseURL + "weather")
//        case .getWeeklyWeather(let coord):
//            components = URLComponents(string: Self.baseURL + "forecast")
//        }
//    }
//
//    func makeURL(url: BaseWeather, by parameters: )
}
