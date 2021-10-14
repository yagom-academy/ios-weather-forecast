//
//  URIBuilder.swift
//  WeatherForecast
//
//  Created by  호싱잉, 잼킹 on 2021/10/08.
//

import Foundation

class URLBuilder: URLMakable {
    var pathType: URLResource.PathType
    var queries = [URLResource.QueryParam]()
    
    init(pathType: URLResource.PathType = .current) {
        self.pathType = pathType
    }
    
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
    
    func buildWeatherURL(resource: URLResource) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = resource.scheme
        urlComponents.host = resource.host
        
        switch pathType {
        case .current:
            urlComponents.path = pathType.rawValue
        case .fiveDays:
            urlComponents.path = pathType.rawValue
        }
        urlComponents.queryItems = queries.map({
            URLQueryItem(name: $0.name, value: $0.value)
        })
        return urlComponents.url
    }
    
    func builderImageURL(resource: URLResource, index: Int) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = resource.scheme
        urlComponents.host = resource.host
        urlComponents.path = URLResource.PathType.weatherImage(num: index)
        return urlComponents.url
    }
}

