//
//  UIViewControllerExtensionError.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/22.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(with error: WeatherForecastError) {
        let alert = UIAlertController(title: "오류 발생", message: "\(String(describing: error.localizedDescription)) 앱을 다시 실행시켜주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAuthorizationAlert(with error: WeatherForecastError) {
        let alert = UIAlertController(title: nil, message: "\(String(describing: error.localizedDescription))\n위치 정보를 허용해야만 날씨를 확인할 수 있습니다.\n 설정화면으로 이동할까요?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "이동", style: .default) { _ in
            self.openSetting()
        }
        let cacelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cacelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
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
        case .failGetAuthorization:
            self.showAlert(with: .failGetAuthorization)
        }
    }
}
