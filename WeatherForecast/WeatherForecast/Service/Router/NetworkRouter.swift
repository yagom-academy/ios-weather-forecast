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
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request)
            print(request.url)
            self.task?.resume()
        } catch {
            print(error)
        }
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    private func buildRequest(from route: EndPointType) throws -> URLRequest {
        guard let url = self.generateBaseURL(route.requestPurpose),
              var urlComponents = URLComponents(url: url,
                                                resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }
     
        switch route.urlElements {
        case .with(let query, and: let path):
            insert(pathComponents: path, to: &urlComponents)
            insert(queryItems: query, to: &urlComponents)
        }
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        return URLRequest(url: url)
    }
    
    private func insert(queryItems: QueryItems?,
                        to urlComponents: inout URLComponents) {
        guard let queryItems = queryItems else {
            return
        }
        
        for (key, value) in queryItems {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            urlComponents.queryItems?.append(queryItem)
        }
    }
    
    private func insert(pathComponents: PathComponents?,
                        to urlComponents: inout URLComponents) {
        guard let pathComponents = pathComponents else {
            return
        }
        
        for key in pathComponents {
            urlComponents.path.appending(key)
        }
    }
    
    private func generateBaseURL(_ purpose: RequestPurpose) -> URL? {
        var urlDescription = ""
        
        switch purpose {
        case .currentWeather, .forecast:
            urlDescription = "https://api.openweathermap.org"
        case .weatherIconImage:
            urlDescription = "https://openweathermap.org"
        }
        
        guard let url = URL(string: urlDescription) else {
            print(NetworkError.invalidURL.description)
            return nil
        }
        
        return url
    }
}
