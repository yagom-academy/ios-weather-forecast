//
//  AlertController.swift
//  WeatherForecast
//
//  Created by 박태현 on 2021/10/19.
//

import Foundation
import UIKit

struct AlertController {

    static func createAlertToGetCoordinate(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { latitudeTextField in
            latitudeTextField.placeholder = "위도"
            latitudeTextField.keyboardAppearance = .alert
            latitudeTextField.keyboardType = .decimalPad
            latitudeTextField.clearButtonMode = .always
        }

        alert.addTextField { longitudeTextField in
            longitudeTextField.placeholder = "경도"
            longitudeTextField.keyboardAppearance = .alert
            longitudeTextField.keyboardType = .decimalPad
            longitudeTextField.clearButtonMode = .always
        }
        return alert
    }
}

extension UIAlertController {
    func addActions(_ actions: UIAlertAction...) {
        for action in actions {
            self.addAction(action)
        }
    }
}
