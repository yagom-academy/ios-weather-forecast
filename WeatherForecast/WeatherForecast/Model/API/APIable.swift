//
//  APIable.swift
//  WeatherForecast
//
//  Created by JINHONG AN on 2021/09/28.
//

import Foundation

protocol APIable {
    var requestType: RequestType { get }
    var url: URL { get }
    var contentType: ContentType { get }
    var parameter: [String:Any]? { get }
}

enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
    
    var methodName: String {
        return self.rawValue
    }
}

enum ContentType {
    case json
    
    var description: String {
        switch self {
        case .json:
            return "application/json"
        }
    }
}
