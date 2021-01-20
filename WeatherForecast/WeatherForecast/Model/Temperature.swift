//
//  Temperature.swift
//  WeatherForecast
//
//  Created by iluxsm on 2021/01/19.
//

import Foundation

struct Temperature: Decodable {
    private let average: Double
    private let maximum: Double
    private let minimum: Double

    var celiusAverage: Double {
        let convertedValue =  UnitTemperature.celsius.converter.value(fromBaseUnitValue: average)
        return (round(convertedValue * 10)) / 10
    }
    var celiusMaximum: Double {
        let convertedValue = UnitTemperature.celsius.converter.value(fromBaseUnitValue: maximum)
        return (round(convertedValue * 10)) / 10
    }
    var celiusMinimum: Double {
        let convertedValue = UnitTemperature.celsius.converter.value(fromBaseUnitValue: minimum)
        return (round(convertedValue * 10)) / 10
    }

    enum CodingKeys: String, CodingKey {
        case average = "temp"
        case maximum = "temp_max"
        case minimum = "temp_min"
    }
}
