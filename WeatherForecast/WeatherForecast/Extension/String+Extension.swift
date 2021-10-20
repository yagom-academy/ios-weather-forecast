//
//  String+Extension.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/10/21.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
