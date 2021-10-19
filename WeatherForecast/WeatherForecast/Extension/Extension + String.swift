//
//  Extension + String.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/15.
//

import Foundation

extension String {
    static func convertTempature(_ tempature: Double) -> String {
       
        let numberFormat = NumberFormatter()
        let minInterDigits = 1
        let minFractionDigits = 1
        let maxFractionDigits = 1
        
        numberFormat.roundingMode = .floor
        numberFormat.minimumIntegerDigits = minInterDigits
        numberFormat.minimumFractionDigits = minFractionDigits
        numberFormat.maximumFractionDigits = maxFractionDigits
        
        guard let text = numberFormat.string(from: NSNumber(value: tempature)) else {
            return ""
        }
        
        return text.appending("°")
    }
    
    static func convertTimeInvervalForLocalizedText(_ timeInterval: TimeInterval?) -> String {
        guard let timeInterval = timeInterval else {
            return ""
        }
        let formatter = DateFormatter()
        
        Locale.preferredLanguages.first.flatMap {
            formatter.locale = Locale(identifier: $0)
        }
        
        let dateFormat = "MM/dd(E) HH시"
        formatter.dateFormat = dateFormat
        return formatter.string(from: Date(timeIntervalSince1970: timeInterval))
    }
}
