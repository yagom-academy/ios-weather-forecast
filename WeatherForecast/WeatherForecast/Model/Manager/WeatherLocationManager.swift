//
//  WeatherLocationManager.swift
//  WeatherForecast
//
//  Created by Kim Do hyung on 2021/10/22.
//

import Foundation
import CoreLocation

class WeatherLocationManager: CLLocationManager {
    private(set) var isSignificantMonitoringEnabled = false
    
    override func startMonitoringSignificantLocationChanges() {
        super.startMonitoringSignificantLocationChanges()
        isSignificantMonitoringEnabled = true
    }
    
    override func stopMonitoringSignificantLocationChanges() {
        super.stopMonitoringSignificantLocationChanges()
        isSignificantMonitoringEnabled = false
    }
}
