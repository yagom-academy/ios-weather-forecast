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
    private let method: Method
    private let url: URL?
    
    func generateRequest() -> URLRequest? {
        guard let url = url else {
            return nil
        }
        
        switch method {
        case .get:
            return URLRequest(url: url)
        }
    }
}

extension APIResource {
    init(method: Method, apiURL: UrlGeneratable) {
        self.method = method
        self.url = apiURL.generateURL()
    }
}
