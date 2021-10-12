//
//  Extenstion+CLLocationManager.swift
//  WeatherForecast
//
//  Created by Yongwoo Marco on 2021/10/12.
//

import CoreLocation

extension CLLocationManager {
    convenience init(desiredAccuracy: CLLocationAccuracy) {
        self.init()
        self.desiredAccuracy = desiredAccuracy
    }
}
