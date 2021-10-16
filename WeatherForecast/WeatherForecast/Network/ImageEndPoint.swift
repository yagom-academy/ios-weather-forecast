//
//  ImageEndPoint.swift
//  WeatherForecast
//
//  Created by kjs on 2021/10/16.
//

import Foundation

enum ImageEndPoint {
    private static let baseURL = "https://openweathermap.org/img/w/"

    case png(iconName: String)

    var urlString: String {
        return Self.baseURL + path
    }

    private var path: String {
        switch self {
        case .png(let iconName):
            return iconName + ".png"
        }
    }
}
