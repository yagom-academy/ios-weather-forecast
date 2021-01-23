//
//  WeatherLocationManagerDelegate.swift
//  WeatherForecast
//
//  Created by 임성민 on 2021/01/23.
//

import Foundation
import CoreLocation

protocol WeatherLocationManagerDelegate: class {
    func setAddress(_ address: String)
    func setLocation(_ location: CLLocation)
}
