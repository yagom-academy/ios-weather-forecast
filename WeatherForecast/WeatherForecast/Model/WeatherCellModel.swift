//
//  FiveDaysForecastViewModel.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/15.
//

import UIKit.UIImage

final class WeatherCellModel {
    var date: String
    var tempature: String
    var weatherIconImage: UIImage?
    var iconPath: String
    
    init(weatherDateText: String,
         tempature: String,
         iconPath: String,
         iconImage: UIImage? = nil) {
        self.date = weatherDateText
        self.tempature = tempature
        self.weatherIconImage = iconImage
        self.iconPath = iconPath
    }
}
