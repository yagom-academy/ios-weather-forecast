//
//  Main.swift
//  WeatherForecast
//
//  Created by sole on 2021/01/19.
//

import Foundation

struct Temperature: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    
    var average: String {
        let average = UnitTemperature.celsius.converter.value(fromBaseUnitValue: temp)
        let averageText = String(format:"%.1f", average)
        return averageText
    }
    
    var minimum: String {
        let minimum = UnitTemperature.celsius.converter.value(fromBaseUnitValue: temp_min)
        let minimumText = String(format:"%.1f", minimum)
        return minimumText
    }
    
    var maximum: String {
        let maximum = UnitTemperature.celsius.converter.value(fromBaseUnitValue: temp_max)
        let maximumText = String(format:"%.1f", maximum)
        return maximumText
    }
}
