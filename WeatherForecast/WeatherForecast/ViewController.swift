//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController {
    private func showAlert(with error: WeatherForecastError) {
        let alert = UIAlertController(title: "오류 발생", message: "\(String(describing: error.localizedDescription)) 앱을 다시 실행시켜주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
