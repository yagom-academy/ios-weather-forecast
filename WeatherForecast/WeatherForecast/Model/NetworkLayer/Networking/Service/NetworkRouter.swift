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

class Router<EndPointType: EndPoint>: NetworkRouter {
    private var task: URLSessionDataTask?

    func request(_ route: EndPointType, _ session: URLSession) {
        let request = self.buildRequest(from: route)
        
        guard let url = request.url else {
            return
        }
        
        task = session.dataTask(with: url)
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    private func buildRequest(from route: EndPointType) -> URLRequest {
        var request = URLRequest(url: route.baseUrl)
        
        switch route.httpTask {
        case .request(withUrlParameters: let urlParameter):
            self.configureRequestUrl(&request, urlParameter)
        }
        
        return request
    }
    
    private func configureRequestUrl(_ request: inout URLRequest, _ urlParameters: Parameters) {
        do {
            try URLManager.configure(urlRequest: &request, with: urlParameters)
        } catch {
            print(error)
        }
    }
}
