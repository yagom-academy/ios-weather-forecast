//
//  ViewControllerExtension.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/20.
//

import UIKit

extension ViewController {
    func showError(_ error: Error, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "오류", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: handler)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
