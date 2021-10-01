//
//  URLRequestBuilder.swift
//  WeatherForecast
//
//  Created by 김준건 on 2021/09/30.
//

import Foundation

enum URLRequestTask {
    
    case requestWithQueryItems
    
    func buildRequest(route: Route, queryItems: [URLQueryItem]?, header: [String:String]?, bodyParameters: [String:Any]?, httpMethod: HTTPMethod) -> URLRequest? {
        guard let url = createURL(route: route, with: queryItems) else { return nil }
        
        var urlRequest: URLRequest?
        switch self {
        case .requestWithQueryItems:
            urlRequest = buildRequstWithQueryItems(route: route, with: queryItems, httpMethod: httpMethod, url: url)
        }
        return urlRequest
    }
    
    private func buildRequstWithQueryItems(route: Route, with parameters: [URLQueryItem]?, httpMethod: HTTPMethod, url: URL) -> URLRequest? {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.type
        
        return urlRequest
    }
    
    private func createURL(route: Route, with queryItems: [URLQueryItem]?) -> URL? {
        var urlComponents = URLComponents(string: route.baseURL)
        urlComponents?.scheme = route.scheme
        urlComponents?.path = route.path
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else { return nil }
        
        return url
    }
}
