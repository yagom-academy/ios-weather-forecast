//
//  DateFormatter + convertDate.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/18.
//

import Foundation

extension DateFormatter {
    func convertDate(intDate: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(intDate))
        locale = Locale(identifier: "Ko-kr")
        dateFormat = "MM/dd(E) HH시"
        return string(from: date)
    }
}
