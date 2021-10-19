//
//  UIViewController+HandleError.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/04.
//

import UIKit

extension UIViewController {
    func handlerError(_ error: Error) {
        let errorObject = ErrorHandler(error: error)
        
        errorObject.printErrorDescription()
    }
}
