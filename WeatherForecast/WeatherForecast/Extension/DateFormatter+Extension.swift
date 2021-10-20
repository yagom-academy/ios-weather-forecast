//
//  DateFormatter+Extension.swift
//  WeatherForecast
//
//  Created by 김준건 on 2021/10/21.
//

import Foundation

extension DateFormatter {
    static func format(date: Int) -> String? {
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(date))
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate(("MM/dd(E) hh"))
        
        return dateFormatter.string(from: date)
    }
}
