//
//  LocationSelectButtonType.swift
//  WeatherForecast
//
//  Created by 김준건 on 2021/10/15.
//

import Foundation

enum LocationSelectButtonType: String {
    case valid = "위치설정"
    case invalid = "위치변경"
    
    var text: String {
        return self.rawValue
    }
}
