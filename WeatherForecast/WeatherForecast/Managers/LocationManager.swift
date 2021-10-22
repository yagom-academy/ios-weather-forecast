//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/12.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager: LocationManagerProtocol

    init(locationManager: LocationManagerProtocol = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
    }
    
    func requestAuthorization(feat delegate: CLLocationManagerDelegate) {
        self.locationManager.locationManagerDelegate = delegate
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        locationManager.startUpdatingLocation()
    }
}
