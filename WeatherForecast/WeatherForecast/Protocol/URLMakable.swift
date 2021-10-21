//
//  URLMakable.swift
//  WeatherForecast
//
//  Created by  호싱잉, 잼킹 on 2021/10/08.
//

import Foundation

protocol URLMakable {
    var urlBuilder: URLBuilder { get }
    var urlResource: URLResource { get }
}

protocol URLPathQuries {
    var pathType: URLResource.PathType { get set }
    var queries: [URLResource.QueryParam] { get set }
}

