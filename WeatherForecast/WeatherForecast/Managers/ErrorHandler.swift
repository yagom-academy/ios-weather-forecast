//
//  ErrorHandler.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/04.
//

import Foundation

class ErrorHandler {
    let error: Error
    init(error: Error) {
        self.error = error
    }
    
    func printErrorDescription() {
        print(error.localizedDescription)
    }
}
