//
//  extension + UIView.swift
//  WeatherForecast
//
//  Created by Theo on 2021/10/21.
//

import UIKit

extension UIView: URLMakable {
    var urlBuilder: URLBuilder {
        return URLBuilder()
    }
    
    var urlResource: URLResource {
        return URLResource()
    }
}
