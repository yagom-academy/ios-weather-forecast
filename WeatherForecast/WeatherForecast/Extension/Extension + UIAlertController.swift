//
//  Extension + UIAlertController.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/11.
//

import UIKit

extension UIAlertController {
    enum NameSpace {
        static let title = "에러"
    }
    
    static func generateErrorAlertController(message: String?) -> UIAlertController {
        let alert = UIAlertController(title: NameSpace.title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        return alert
    }
}
