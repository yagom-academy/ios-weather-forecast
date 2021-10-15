//
//  Extension + String.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/15.
//

import Foundation

extension String {
    static func formattingTempature(_ tempature: Double?) -> String? {
        guard let tempature = tempature else {
            return nil
        }
        
        let numberFormat = NumberFormatter()
        let minInterDigits = 1
        let minFractionDigits = 1
        let maxFractionDigits = 1
        
        numberFormat.roundingMode = .floor
        numberFormat.minimumIntegerDigits = minInterDigits
        numberFormat.minimumFractionDigits = minFractionDigits
        numberFormat.maximumFractionDigits = maxFractionDigits
        
        let formattingText = numberFormat.string(from: NSNumber(value: tempature))
        
        return formattingText?.appending("°")
    }
}
