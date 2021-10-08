//
//  URLMakable.swift
//  WeatherForecast
//
//  Created by Theo on 2021/10/08.
//

import Foundation

protocol URLMakable {
    var pathType: URLResource.PathType { get set }
    var queries: [URLResource.QueryParam] { get set }
}
