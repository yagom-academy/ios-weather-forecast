//
//  NetworkRouter.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/28.
//

import Foundation

protocol NetworkRouter {
    associatedtype EndPointType = EndPoint
    
    func request(_ route: EndPointType, _ session: URLSession)
    func cancel()
}

final class Router<EndPointType: EndPoint>: NetworkRouter {
    private var task: URLSessionDataTask?
    
    func request(_ route: EndPointType, _ session: URLSession) {
        let request = self.buildRequest(from: route)
        
        task = session.dataTask(with: request)
        
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    private func buildRequest(from route: EndPointType) -> URLRequest {
        var request = URLRequest(url: route.baseUrl)
        request.url?.appendPathComponent(route.path.rawValue, isDirectory: false)
        
        switch route.httpTask {
        case .request(withUrlParameters: let urlParameter):
            do {
                try URLManager.configure(urlRequest: &request, with: urlParameter)
            } catch {
                print(error)
            }
        }

        return request
    }
}
