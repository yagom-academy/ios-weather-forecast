//
//  String + Extension.swift
//  WeatherForecast
//
//  Created by JINHONG AN on 2021/10/19.
//

import Foundation

extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
