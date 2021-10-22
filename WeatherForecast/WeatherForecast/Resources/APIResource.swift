//
//  APIResource.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/09/30.
//

import Foundation

enum Method {
    case get
}

struct APIResource: RequestGeneratable {
    private let url: UrlGeneratable
    
    func generateRequest() -> URLRequest? {
        guard let url = url.generateURL() else {
            return nil
        }
        
        switch self.url.method {
        case .get:
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem]()
            self.url.parameter?.forEach({ key, value in
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components?.queryItems?.append(queryItem)
            })
            guard let url = components?.url else { return nil }
            return URLRequest(url: url)
        }
    }
}

extension APIResource {
    init(apiURL: UrlGeneratable) {
        self.url = apiURL
    }
}
