//
//  Extension+UIViewController.swift
//  WeatherForecast
//
//  Created by Yongwoo Marco on 2021/10/21.
//

import UIKit

extension UIViewController {
    enum ChangeLocation: CustomStringConvertible, CaseIterable {
        case change
        case select
        case cancel
        
        var description: String {
            switch self {
            case .change:
                return "변경"
            case .select:
                return "현재 위치로 재설정"
            case .cancel:
                return "취소"
            }
        }
    }
    
    func presentChangeLocationAlert(title: String, message: String, options: [ChangeLocation],
                                    completion: @escaping ((latitude: String?, longitude: String?), ChangeLocation) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { latitudeTextField in
            latitudeTextField.placeholder = "위도"
            latitudeTextField.keyboardType = .decimalPad
        }
        alertController.addTextField { longitudeTextField in
            longitudeTextField.placeholder = "경도"
            longitudeTextField.keyboardType = .decimalPad
        }
        for option in options {
            let alertAction = UIAlertAction(title: option.description, style: .default) { _ in
                completion((latitude: alertController.textFields?[0].text,
                            longitude: alertController.textFields?[1].text), option)
            }
            alertController.addAction(alertAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentWarningAlert(title: String, message: String, options: String...,
                             completion: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for option in options {
            let alertAction = UIAlertAction(title: option, style: .default) { _ in
                completion(option)
            }
            alertController.addAction(alertAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
