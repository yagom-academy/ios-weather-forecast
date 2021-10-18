//
//  LocationProtocol.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/14.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol {
    var locationManagerDelegate: LocationManagerDelegate? { get set }
    func requestLocation()
    func requestWhenInUseAuthorization()
}

protocol LocationManagerDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus)
}

extension CLLocationManager: LocationManagerProtocol {
    var locationManagerDelegate: LocationManagerDelegate? {
        get {
            guard let delegate = delegate as? LocationManagerDelegate else { return nil }
            return delegate
        }
        set {
            guard let newValue = newValue else { return }
            delegate = newValue
        }
    }
}
