//
//  Main.swift
//  WeatherForecast
//
//  Created by sole on 2021/01/19.
//

import Foundation

struct Temperature: Decodable {
    let kelvinAverage: Double
    let kelvinMinimum: Double
    let kelvinMaximum: Double
    
    enum CodingKeys: String, CodingKey {
        case kelvinAverage = "temp"
        case kelvinMinimum = "temp_min"
        case kelvinMaximum = "temp_max"
    }
    
    var selsiusAverage: String {
        let average = UnitTemperature.celsius.converter.value(fromBaseUnitValue: kelvinAverage)
        let averageText = String(format:"%.1f", average)
        return averageText
    }
    
    var selsiusMinimum: String {
        let minimum = UnitTemperature.celsius.converter.value(fromBaseUnitValue: kelvinMinimum)
        let minimumText = String(format:"%.1f", minimum)
        return minimumText
    }
    
    var selsiusMaximum: String {
        let maximum = UnitTemperature.celsius.converter.value(fromBaseUnitValue: kelvinMaximum)
        let maximumText = String(format:"%.1f", maximum)
        return maximumText
    }
}
