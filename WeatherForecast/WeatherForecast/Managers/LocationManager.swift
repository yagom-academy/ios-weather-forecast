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
    
    private let locationManager = CLLocationManager()
    private var completionHanler: RequestLocationAction?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
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
