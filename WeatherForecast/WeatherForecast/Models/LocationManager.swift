//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by yun on 2021/10/05.
//

import CoreLocation.CLLocationManager

final class LocationManager: CLLocationManager {
    
    var lastLocation: Location?
    
    func askUserLocation() {
        self.requestWhenInUseAuthorization()
    }
    
    override init() {
        super.init()
        self.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
}
