//
//  TextValue.swift
//  WeatherForecast
//
//  Created by sole on 2021/01/21.
//

import Foundation

enum App {
    case key
    case cuurentWeather
    case fivedaysForecast
    
    var text: String {
        switch self {
        case .key:
            return "179f9f1734b59fcdd8627cb64e9fae5d"
        default:
            return "key값 오류"
        }
    }
    
    var URL: String {
        switch self {
        case .cuurentWeather:
            return "https://api.openweathermap.org/data/2.5/weather?"
        case .fivedaysForecast:
            return "https://api.openweathermap.org/data/2.5/forecast?"
        default:
            return "URL 오류"
        }
    }
    
    enum coordinate {
        case latitude
        case longtitude
        
        var value: Double {
            switch self {
            case .latitude:
                return 37.68382
            case .longtitude:
                return 126.742401
            }
        }
    }
}
