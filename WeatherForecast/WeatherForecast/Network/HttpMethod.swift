//
//  HttpMethod.swift
//  WeatherForecast
//
//  Created by kjs on 2021/09/30.
//

import Foundation

enum HttpMethod: String, CaseIterable {
    var description: String {
        return self.rawValue
    }

    case `get` = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}
