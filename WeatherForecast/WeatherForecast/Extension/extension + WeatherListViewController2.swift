//
//  extension + WeatherListViewController2.swift
//  WeatherForecast
//
//  Created by Theo on 2021/10/21.
//

import UIKit

extension WeatherListViewController: URLMakable {
    var urlBuilder: URLBuilder {
        return URLBuilder()
    }
    
    var urlResource: URLResource {
        return URLResource()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
