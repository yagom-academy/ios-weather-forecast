//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/14.
//

import Foundation
import UIKit.UIImage

final class WeatherHeaderModel {
    var address: String
    var minTempature: String
    var maxTempature: String
    var currentTempature: String
    var iconImage: UIImage?
   
    init(address: String,
         minTempature: String,
         maxTempature: String,
         currentTempature: String,
         iconImage: UIImage?) {
        self.address = address
        self.minTempature = minTempature
        self.maxTempature = maxTempature
        self.currentTempature = currentTempature
        self.iconImage = iconImage
    }
}
