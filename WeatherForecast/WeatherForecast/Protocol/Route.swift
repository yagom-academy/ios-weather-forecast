//
//  Route.swift
//  WeatherForecast
//
//  Created by 김준건 on 2021/09/30.
//

import Foundation

protocol Route {
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
}
