//
//  LocationButton.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/19.
//

import UIKit

enum UserState {
    case able
    case disable
    
    var buttonTitle: String {
        switch self {
        case .able:
            return "위치변경"
        case .disable:
            return "위치설정"
        }
    }
}
