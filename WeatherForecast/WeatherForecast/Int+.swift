//
//  Int+.swift
//  WeatherForecast
//
//  Created by 이윤주 on 2021/10/19.
//

import Foundation

extension Int {
    func converToDateFormat() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "MM/dd(E) HH시"
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let formattedDate = formatter.string(from: date)
        
        return formattedDate
    }
}
