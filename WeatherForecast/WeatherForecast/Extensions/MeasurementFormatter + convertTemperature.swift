//
//  MeasurementFormatter + convertTemperature.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/18.
//

import Foundation

extension MeasurementFormatter {
    func convertTemperature(temp: Double) -> String {
        numberFormatter.maximumFractionDigits = 1
        unitOptions = .providedUnit
        let input = Measurement(value: temp,
                                unit: UnitTemperature.kelvin)
        let output = input.converted(to: UnitTemperature.celsius)
        guard let result = numberFormatter.string(for: output.value) else {
            return "" }
        return result + "°"
    }
}
