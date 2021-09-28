//
//  NetworkRouter.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/28.
//

import Foundation

typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

protocol NetworkRouter {
    //associatedtype EndPointType = EndPoint
    
    func request(_ route: EndPoint)
    func cancel()
}

class Router: NetworkRouter {
    func request(_ route: EndPoint) {
    }
    
    func cancel() {
    }
    
    func buildRequest(url: EndPoint) -> URLRequest {
        let request = URLRequest(url: url.baseUrl)
        return request
    }
}
