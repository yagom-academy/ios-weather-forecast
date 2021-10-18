//
//  Extension + CLLocation.swift
//  WeatherForecast
//
//  Created by 박태현 on 2021/10/18.
//

import Foundation
import CoreLocation

extension CLLocation {
    convenience init(coordinate: Coordinate) {
        self.init(latitude: coordinate.lat, longitude: coordinate.lon)
    }
}
