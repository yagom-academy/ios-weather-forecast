//
//  LocationSelectButtonType.swift
//  WeatherForecast
//
//  Created by 김준건 on 2021/10/15.
//

import Foundation

enum LocationSelectButtonType: String {
    case valid = "Set Location"
    case invalid = "Change Location"
    
    var text: String {
        return self.rawValue.localized()
    }
}
