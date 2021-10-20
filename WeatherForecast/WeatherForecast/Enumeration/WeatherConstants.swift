//
//  Placeholder.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/10/15.
//

import Foundation

enum WeatherConstants: String {
    case date
    case latitude = "Latitude"
    case longitude = "Longitude"
    case changeLocation = "Change Location"
    case setLocation = "Set Location"
    case change = "Change"
    case cancel = "Cancel"
    case initFailure = "init(coder:) has not been implemented"
    
    var text: String {
        return self.rawValue.localized()
    }
}
