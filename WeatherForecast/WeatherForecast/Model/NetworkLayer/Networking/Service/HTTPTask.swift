//
//  HTTPTask.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/28.
//

import Foundation
typealias Parameters = [String: Any]

enum HTTPTask {
    case request(withUrlParameters: Parameters)
}
