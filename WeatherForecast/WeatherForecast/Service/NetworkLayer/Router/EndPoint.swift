//
//  EndPoint.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/28.
//

import Foundation
typealias QueryItems = [String: Any]
typealias PathComponents = [String]

protocol EndPoint {
    var httpMethod: HTTPMethod { get }
    var baseUrl: URL { get }
    var path: URLPath? { get }
    var qeury: QueryItems? { get }
}

struct OpenWeatherAPI: EndPoint {
    var httpMethod: HTTPMethod
    var baseUrl: URL
    var path: URLPath?
    var qeury: QueryItems?
}
