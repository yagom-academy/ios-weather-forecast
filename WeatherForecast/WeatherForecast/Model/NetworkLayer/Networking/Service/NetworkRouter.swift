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
    var data: FiveDaysForecast?
    
    func request(_ route: EndPointType, _ session: URLSession) {
        let request = self.buildRequest(from: route)
        
        guard let url = request.url else {
            return
        }
        
        task = session.dataTask(with: url) { data, reponse, error in
            guard error == nil else  {
                return
            }
            
            guard let response = reponse as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                return
            }
            
            guard let data = data else {
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(FiveDaysForecast.self, from: data)
            } catch {
                print(error)
            }
        }
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
