//
//  Extension+NSObject.swift
//  WeatherForecast
//
//  Created by Yongwoo Marco on 2021/10/13.
//

import Foundation.NSObject

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
    var className: String {
        return type(of: self).className
    }
}
