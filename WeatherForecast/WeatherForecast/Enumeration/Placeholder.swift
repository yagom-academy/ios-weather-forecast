//
//  Placeholder.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/10/15.
//

import Foundation

enum Placeholder: String {
    case date = "날짜/시간"
    case latitude = "위도"
    case longitude = "경도"
    
    var text: String {
        return self.rawValue
    }
}
