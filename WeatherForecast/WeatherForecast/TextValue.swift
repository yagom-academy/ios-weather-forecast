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
        let url = "https://api.openweathermap.org/data/2.5/"
        switch self {
        case .cuurentWeather:
            return "\(url)weather?"
        case .fivedaysForecast:
            return "\(url)forecast?"
        default:
            return "URL 오류"
        }
    }
}

enum DefaultLocation {
    case latitude
    case longtitude
    
    var value: Double {
        switch self {
        case .latitude:
            return 37.659835498082685
        case .longtitude:
            return 126.33721714704042
        }
    }
}

enum DefaultAddress {
    case address
    
    var value: String {
        switch self {
        case .address:
            return ""
        }
    }
}

enum Error {
    case userDenied
    case locationManagerError
    case geocodeLocationError
    
    var message: String {
        switch self {
        case .userDenied:
            return "사용자 거절"
        case .locationManagerError:
            return "위치정보 없음"
        case .geocodeLocationError:
            return "주소정보 없음"
        }
    }
    
}
