//
//  NetworkError.swift
//  WeatherForecast
//
//  Created by 이예원 on 2021/10/05.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
}
