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
    
    func request(_ route: EndPoint, _ session: URLSession)
    func cancel()
}

class Router: NetworkRouter {
    private var task: URLSessionDataTask?
    
    func request(_ route: EndPoint, _ session: URLSession) {
        do {
            let request = try self.buildRequest(from: route)
            guard let url = request.url else {
                return
            }
            task = session.dataTask(with: url)
        } catch {
            print(error)
        }
        self.task?.resume()
    }
    
    func cancel() {
    }
    
    func buildRequest(from route: EndPoint) throws -> URLRequest {
        let request = URLRequest(url: route.baseUrl)
        return request
    }
}
