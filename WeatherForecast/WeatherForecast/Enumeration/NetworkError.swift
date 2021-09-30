//
//  NetworkError.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/09/29.
//

import Foundation

enum NetworkError: LocalizedError {
    case badResponse
    case dataIntegrityError
    case invalidURL
}
