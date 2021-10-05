//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by 김준건 on 2021/10/05.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.requestLocation()
    }
    
    func getGeographicCoordinates() -> CLLocation? {
        manager.startUpdatingLocation()
        guard let location = manager.location else { return nil }
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return location
        default:
            return nil
        }
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        return
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
