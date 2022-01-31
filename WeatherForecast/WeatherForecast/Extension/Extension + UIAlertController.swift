//
//  Extension + UIAlertController.swift
//  WeatherForecast
//
//  Created by 박태현 on 2021/10/21.
//

import UIKit

extension UIAlertController {
    func addActions(_ actions: UIAlertAction...) {
        for action in actions {
            self.addAction(action)
        }
    }
}
