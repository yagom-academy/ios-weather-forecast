//
//  Extension + MeasurementFormatter.swift
//  WeatherForecast
//
//  Created by 박태현 on 2021/10/13.
//

import Foundation

extension MeasurementFormatter {
    func convertTemp(temp: Double,
                     from inputTempType: UnitTemperature,
                     to outputTempType: UnitTemperature) -> String {
        self.numberFormatter.maximumFractionDigits = 1
        self.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        guard let result = numberFormatter.string(from: NSNumber(value: output.value)) else {
            return "missed"
        }
        return result + "°"
    }
}
