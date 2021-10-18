//
//  TestLocationManager.swift
//  WeatherForecastTests
//
//  Created by YongHoon JJo on 2021/10/16.
//

import Foundation
import CoreLocation
@testable import WeatherForecast

class MockLocationManager: LocationManagerProtocol {
    weak var delegate: CLLocationManagerDelegate?
    var locationManagerDelegate: CLLocationManagerDelegate? {
        get {
            return self.delegate
        }
        set {
            self.delegate = newValue
        }
    }
    private let location: CLLocation
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        location = CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func requestWhenInUseAuthorization() {
        
    }
    
    func startUpdatingLocation() {
        let locations = [location]
        locationManagerDelegate?.locationManager?(CLLocationManager(), didUpdateLocations: locations)
    }
    
    func stopUpdatingLocation() {
        
    }
}
