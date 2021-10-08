//
//  WeatherURL.swift
//  WeatherForecast
//
//  Created by 잼킹, 호싱잉 on 2021/10/08.
//

import Foundation

struct WeatherURL: URLMakable {
    var pathType: URLResource.PathType
    var queries: [URLResource.QueryParam]
}

