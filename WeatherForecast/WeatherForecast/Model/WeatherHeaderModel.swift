//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/14.
//

import Foundation

final class WeatherHeaderModel {
    var address: String
    var minTempature: String
    var maxTempature: String
    var currentTempature: String
    var iconData: Data
   
    init(address: String,
         minTempature: String,
         maxTempature: String,
         currentTempature: String,
         iconData: Data) {
        self.address = address
        self.minTempature = minTempature
        self.maxTempature = maxTempature
        self.currentTempature = currentTempature
        self.iconData = iconData
    }
}
