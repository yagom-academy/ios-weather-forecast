//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/12.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var completion: ((CLLocation) -> Void)?
    
    func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        locationManager.delegate = self
        locationManager.startUpdatingLocation()()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        currentCoodinate = location
        completion?(location)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
}
