//
//  extension + Double.swift
//  WeatherForecast
//
//  Created by Theo on 2021/10/15.
//

import Foundation

extension Double {
    func convertToCelsius() -> Double {
        self - 273.15
    }
    
    func convertToFahrenheit() -> Double {
        self * 1.8 + 32
    }
}
