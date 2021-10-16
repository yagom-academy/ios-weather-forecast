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
    var customDelegate: CLLocationManagerDelegate? {
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
        customDelegate?.locationManager?(CLLocationManager(), didUpdateLocations: locations)
    }
    
    func stopUpdatingLocation() {
        
    }
}
