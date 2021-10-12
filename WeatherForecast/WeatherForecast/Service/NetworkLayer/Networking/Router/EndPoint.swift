//
//  EndPoint.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/28.
//

import Foundation

protocol EndPoint {
    var httpTask: HTTPTask { get }
    var httpMethod: HTTPMethod { get }
    var baseUrl: URL { get }
    var path: Path { get }
}

struct OpenWeatherApi: EndPoint {
    var httpTask: HTTPTask
    var httpMethod: HTTPMethod
    var baseUrl: URL
    var path: Path
}

enum Path: String {
    case weather
    case forecast
}
