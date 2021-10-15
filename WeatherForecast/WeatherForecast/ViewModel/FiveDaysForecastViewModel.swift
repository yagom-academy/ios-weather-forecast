//
//  FiveDaysForecastViewModel.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/15.
//

import Foundation

final class FiveDaysForecastViewModel {
    var date: String?
    var tempature: String?
    var weatherIconData: Data?
    
    init(weatherDateText: String, tempature: String, iconData: Data) {
        self.date = weatherDateText
        self.tempature = tempature
        self.weatherIconData = iconData
    }
}
