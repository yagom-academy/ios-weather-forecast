//
//  Main.swift
//  WeatherForecast
//
//  Created by sole on 2021/01/19.
//

import Foundation

struct Temperature: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    
    var average: String {
        let averageText = String(format:"%.1f", (temp-32)/1.8)
        return averageText
    }
    var minimum: String {
        let minimumText = String(format:"%.1f", (temp_min-32)/1.8)
        return minimumText
    }
    var maximum: String {
        let maximumText = String(format:"%.1f", (temp_max-32)/1.8)
        return maximumText
    }
}
