//
//  MockLocationManager.swift
//  WeatherForecastTests
//
//  Created by tae hoon park on 2021/10/14.
//

import Foundation
import CoreLocation
@testable import WeatherForecast

class MockLocationManager: LocationManagerProtocol {
    weak var locationManagerDelegate: LocationManagerDelegate?
    var locationCompletion: (() -> CLLocation)?
    func requestLocation() {
        guard let location = locationCompletion?() else { return }
        locationManagerDelegate?.locationManager(CLLocationManager(),
                                                 didUpdateLocations: [location])
    }
    
    func requestWhenInUseAuthorization() {
        locationManagerDelegate?.locationManager(CLLocationManager(),
                                                 didChangeAuthorization: .authorizedWhenInUse)
    }
}
