//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/12.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    var locationManager = CLLocationManager()
    
    func setupLocationInfo() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

// MARK:- CLLocationManagerDelegate
extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            return
        }

        let longitude = currentLocation.coordinate.longitude
        let latitude = currentLocation.coordinate.latitude

        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
