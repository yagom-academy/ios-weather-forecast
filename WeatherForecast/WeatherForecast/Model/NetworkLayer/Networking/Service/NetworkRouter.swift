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
        self.task?.cancel()
    }
    
    private func buildRequest(from route: EndPointType) throws -> URLRequest {
        var request = URLRequest(url: route.baseUrl)
        do {
            switch route.httpTask {
            case .requestWithUrlParameters(urlParameters: let urlParameter):
                try self.configureUrlParameter(&request, urlParameter)
            }
        } catch {
            print(error)
        }
        
        return request
    }
    
    private func configureUrlParameter(_ request: inout URLRequest, _ urlParameters: Parameters) throws {
        do {
            try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
        } catch {
            print(error)
        }
    }
}
