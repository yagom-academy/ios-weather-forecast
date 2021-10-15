//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/14.
//

import Foundation

final class WeatherHeaderViewModel {
    var address: String
    var minTempature: String
    var maxTempature: String
    var currentTempature: String
    var iconData: Data
   
    init(_ viewModel : WeatherHeaderViewModel) {
        self.address = viewModel.address
        self.minTempature = viewModel.minTempature
        self.maxTempature = viewModel.maxTempature
        self.currentTempature = viewModel.currentTempature
        self.iconData = viewModel.iconData
    }
}
