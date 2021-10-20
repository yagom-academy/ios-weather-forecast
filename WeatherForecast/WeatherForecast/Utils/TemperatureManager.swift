//
//  TemperatureManager.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/10/18.
//

import Foundation

final class TemperatureManager: Dimension {
    
    /// 온도를 변환 후 fractionalCount 자리까지 반올림해주는 메서드
    static func convert(kelvinValue: Double, fractionalCount: Int) -> String {
        let tempData: Double
        let symbol: String
        
        if Locale.current.usesMetricSystem == true {
            tempData = UnitTemperature.celsius.converter.value(fromBaseUnitValue: kelvinValue)
            symbol = "°C"
        } else {
            tempData = UnitTemperature.fahrenheit.converter.value(fromBaseUnitValue: kelvinValue)
            symbol = "°F"
        }
        
        let digitShifter = NSDecimalNumber(decimal: pow(10, fractionalCount)).doubleValue
        let rounded = round(tempData * digitShifter) / digitShifter
        
        return rounded.description + symbol
    }
}
