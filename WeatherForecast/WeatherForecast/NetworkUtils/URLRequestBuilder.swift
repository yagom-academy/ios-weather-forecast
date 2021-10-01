//
//  URLRequestBuilder.swift
//  WeatherForecast
//
//  Created by 김준건 on 2021/09/30.
//

import Foundation

struct URLRequestBuilder {
    
    func buildRequest(route: Route, with parameters: [URLQueryItem], httpMethod: HTTPMethod) -> URLRequest? {
        guard let url = createURL(route: route, with: parameters) else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.type
        
        return urlRequest
    }
    
    private func createURL(route: Route, with parameters: [URLQueryItem]) -> URL? {
        var urlComponents = URLComponents(string: route.baseURL)
        urlComponents?.scheme = route.scheme
        urlComponents?.path = route.path
        urlComponents?.queryItems = parameters
        
        guard let url = urlComponents?.url else { return nil }
        
        return url
    }
}
