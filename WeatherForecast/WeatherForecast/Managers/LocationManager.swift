//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/12.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    typealias RequestLocationAction = (CLLocationCoordinate2D) -> Void
    
    private var locationManager: LocationManagerProtocol
    private var completionHanler: RequestLocationAction?

    init(locationManager: LocationManagerProtocol = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        
        self.locationManager.customDelegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation(completion: @escaping RequestLocationAction) {
        completionHanler = completion
        locationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            return
        }

        completionHanler?(currentLocation.coordinate)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
