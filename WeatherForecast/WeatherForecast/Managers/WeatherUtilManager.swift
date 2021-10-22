//
//  WeatherUtilManager.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/22.
//

import Foundation

class WeatherUtilManager {
    static func convertToCelsius(on fahrenheit: Double?) -> String {
        guard let fahrenheit = fahrenheit else {
            return " "
        }
        return "\(String(format: "%.2f", fahrenheit - 273.15)) ℃"
    }
    
    static func convertString2DateType(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.date(from: string)
    }
    
    static func convertDateType2String(_ date: Date?) -> String {
        guard let date = date else {
            return "-"
        }
        
        let dateFommatter = DateFormatter()
        dateFommatter.locale = Locale(identifier: "ko_KR")
        dateFommatter.timeZone = TimeZone(abbreviation: "KST")
        dateFommatter.dateFormat = "MM/dd (E) HH시"
        
        return dateFommatter.string(from: date)
    }
    
    static func parseDateInfo(on dateText: String?) -> String {
        guard let dateText = dateText else {
            return " "
        }
        let dateType = convertString2DateType(dateText)
        return convertDateType2String(dateType)
    }
}
