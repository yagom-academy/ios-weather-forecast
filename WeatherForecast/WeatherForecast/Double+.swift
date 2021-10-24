//
//  Double+.swift
//  WeatherForecast
//
//  Created by 이윤주 on 2021/10/19.
//

import Foundation

extension Double {
    func convertToCelsius() -> Double {
        let celsius = self - 273.15
        let result = (celsius * 10).rounded() / 10
        return result
    }
}
