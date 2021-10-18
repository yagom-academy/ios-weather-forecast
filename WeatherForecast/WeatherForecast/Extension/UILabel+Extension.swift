//
//  UILabel+Extension.swift
//  WeatherForecast
//
//  Created by 김준건 on 2021/10/18.
//

import Foundation
import UIKit

extension UILabel {
    static var color = UIColor.systemGray6
    static func makeLabel(font: UIFont.TextStyle, text: String = "-") -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UILabel.color
        label.font = UIFont.preferredFont(forTextStyle: font)
        label.text = text
        return label
    }
}

