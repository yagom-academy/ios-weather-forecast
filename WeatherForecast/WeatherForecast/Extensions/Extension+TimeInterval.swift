//
//  Extension+TimeInterval.swift
//  WeatherForecast
//
//  Created by Yongwoo Marco on 2021/10/19.
//

import Foundation.NSDateInterval

extension TimeInterval {
    func dateFormatString(locale: Locale = Locale(identifier: "ko-KR")) -> String {
        let dateFormmater = DateFormatter()
        dateFormmater.locale = locale
        dateFormmater.dateFormat = "MM/dd(EEE) HH시"
        let convertedDate = Date(timeIntervalSince1970: self)
        return dateFormmater.string(from: convertedDate)
    }
}
