//
//  URIBuilder.swift
//  WeatherForecast
//
//  Created by Theo on 2021/10/08.
//

import Foundation

class URLBuilder: URLMakable {
    var pathType: URLResource.PathType = .current
    var queries = [URLResource.QueryParam]()
    
    func setPathType(_ pathType: URLResource.PathType) {
        self.pathType = pathType
    }
    
    func addQuery(_ query: URLResource.QueryParam) {
        queries.append(query)
    }
    
    func addQueries(_ queries: [URLResource.QueryParam]) {
        self.queries.append(contentsOf: queries)
    }
    
    func removeAllQueries() {
        queries.removeAll()
    }
    
    func build(resource: URLResource) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = resource.scheme
        urlComponents.host = resource.host
        
        switch pathType {
        case .current:
            urlComponents.path = URLResource.PathType.current.rawValue
        case .fiveDay:
            urlComponents.path = URLResource.PathType.fiveDay.rawValue
        }
        urlComponents.queryItems = queries.map({
            URLQueryItem(name: $0.name, value: $0.value)
        })
        return urlComponents.url
    }
}

