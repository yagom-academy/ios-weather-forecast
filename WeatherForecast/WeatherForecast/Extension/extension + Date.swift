//
//  extension + Date.swift
//  WeatherForecast
//
//  Created by Theo on 2021/10/15.
//

import Foundation

var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_kr")
    formatter.dateFormat = "MM / dd (EEEEE) HH"
    return formatter
}()
