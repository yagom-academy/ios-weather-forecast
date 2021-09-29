//
//  File.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/09/29.
//

import Foundation

enum Period {
    case current
    case fiveDay
    
    var path: String {
        switch self {
        case .current:
            return "weather"
        case .fiveDay:
            return "forecast"
        }
    }
}
