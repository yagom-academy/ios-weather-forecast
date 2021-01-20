//
//  ViewControllerExtension.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/20.
//

import UIKit
import CoreLocation

extension ViewController {
    func makeErrorAlert(_ error: Error, handler: ((UIAlertAction) -> Void)?) -> UIAlertController {
        var errorMessage: String
        
        if let weatherForcastError = error as? WeatherForcastError {
            errorMessage = weatherForcastError.localizedDescription
        } else if let clLocationError = error as? CLError {
            errorMessage = clLocationError.localizedDescription
        } else {
            errorMessage = WeatherForcastError.unknown.localizedDescription
        }
        
        let alertController = UIAlertController(title: "오류", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: handler)
        alertController.addAction(okAction)
        return alertController
    }
}
