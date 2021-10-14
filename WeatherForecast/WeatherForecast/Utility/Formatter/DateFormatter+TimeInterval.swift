//
//  DateFormatter+TimeInterval.swift
//  WeatherForecast
//
//  Created by Dasoll Park on 2021/10/14.
//

import Foundation

extension TimeInterval {
    
    func format(locale: Locale = Locale(identifier: "ko_KR")) -> String {
        let time = Date(timeIntervalSince1970: self)
        let date = DateFormatter()
        
        date.locale = locale
        date.dateFormat = "MM/dd(E) HH시"
        return date.string(from: time)
    }
}
