//
//  WeatherHeader.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/10/14.
//

import Foundation
import UIKit.UIImage

struct WeatherHeader: Hashable {
    let address: String
    let maxTemperature: String
    let minTemperature: String
    let temperature: String
    let image: UIImage?
    
    init(address: String,
         minTemperature: String,
         maxTemperature: String,
         temperature: String,
         weatherIcon: UIImage)
    {
        self.address = address
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
        self.temperature = temperature
        self.image = weatherIcon
    }
    
    init() {
        self.address = ""
        self.maxTemperature = ""
        self.minTemperature = ""
        self.temperature = ""
        self.image = UIImage(systemName: "photo")
    }
}
