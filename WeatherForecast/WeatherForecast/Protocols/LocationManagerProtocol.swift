//
//  LocationManagerProtocol.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/14.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol {
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
    var customDelegate: CLLocationManagerDelegate? { get set }
}

extension CLLocationManager: LocationManagerProtocol {
    var customDelegate: CLLocationManagerDelegate? {
        get {
            return self.delegate
        }
        set {
            self.delegate = newValue
        }
    }
}
