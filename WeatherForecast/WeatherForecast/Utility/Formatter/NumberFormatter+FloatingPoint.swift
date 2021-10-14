//
//  NumberFormatter+FloatingPoint.swift
//  WeatherForecast
//
//  Created by Soll on 2021/10/14.
//

import Foundation

extension FloatingPoint {
    
    func franctionDisits(
        maxDisits: Int = 1,
        roundingMode: NumberFormatter.RoundingMode = .halfEven
    ) -> String {
        let formatter = NumberFormatter()
        
        formatter.maximumFractionDigits = maxDisits
        formatter.roundingMode = roundingMode
        return formatter.string(for: self) ?? "\(self)"
    }
}
