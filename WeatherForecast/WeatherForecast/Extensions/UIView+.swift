//
//  UIView+.swift
//  WeatherForecast
//
//  Created by WANKI KIM on 2021/10/15.
//

import UIKit

extension UIView {
    func addSubViews(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addArrangedSubview(view)
        }
    }
}
