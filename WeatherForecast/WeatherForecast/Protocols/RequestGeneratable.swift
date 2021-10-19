//
//  RequestGeneratable.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/03.
//

import Foundation

protocol RequestGeneratable {
    func generateRequest() -> URLRequest?
}
