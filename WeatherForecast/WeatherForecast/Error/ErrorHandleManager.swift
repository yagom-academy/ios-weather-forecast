//
//  ErrorHandleManager.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/22.
//

import Foundation
import UIKit

final class ErrorHandleManager: UIViewController {
    func showAlert(with error: WeatherForecastError) {
        let alert = UIAlertController(title: "오류 발생", message: "\(String(describing: error.localizedDescription)) 앱을 다시 실행시켜주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func errorHandling(error: WeatherForecastError) {
        switch error {
        case .failGetCurrentLocation:
            DispatchQueue.main.async {
                self.showAlert(with: .failGetCurrentLocation)
            }
        case .failFetchData:
            DispatchQueue.main.async {
                self.showAlert(with: .failFetchData)
            }
        case .failMatchingMimeType:
            DispatchQueue.main.async {
                self.showAlert(with: .failMatchingMimeType)
            }
        case .failTransportData:
            DispatchQueue.main.async {
                self.showAlert(with: .failTransportData)
            }
        case .failGetData:
            DispatchQueue.main.async {
                self.showAlert(with: .failGetData)
            }
        case .failDecode:
            DispatchQueue.main.async {
                self.showAlert(with: .failDecode)
            }
        }
    }
}
