//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by Soll on 2021/10/08.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    private var completion: ((CLLocation) -> Void)?
    
    override init() {
        super.init()
        
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
    }
    
    func getUserLocation(completion: @escaping (CLLocation) -> Void) {
        self.completion = completion
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        completion?(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
