//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by WANKI KIM on 2021/10/12.
//

import Foundation
import CoreLocation

class WeatherLocationManager: CLLocationManager {
    override init() {
        super.init()
        self.requestWhenInUseAuthorization()
        self.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        // To begin receiving coordinates, you have to call its startUpdatingLocation() method first.
        self.startUpdatingLocation()
    }
}
