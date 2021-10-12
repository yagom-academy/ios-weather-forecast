//
//  LocationError.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/12.
//

import Foundation

enum LocationError: Error, LocalizedError {
    case unknown(description: String)
    case invalidPlacemarks
    
    var errorDescription: String? {
        switch self {
        case .unknown(description: let description):
            return "Unknown: \(description)."
        case .invalidPlacemarks:
            return "Invalid placemarks."
        }
    }
}
