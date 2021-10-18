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
    
    private var locationManager: LocationManagerProtocol
    private var completionHanler: RequestLocationAction?
    
    init(locationManager: LocationManagerProtocol = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        
        self.locationManager.locationManagerDelegate = self
    }
    
    func requestAuthorization(completion: @escaping RequestLocationAction) {
        completionHanler = completion
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
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
        // TODOs: 좌표정보 직접 입력받거나 현재 위치 재설정 알럿 띄우기
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            // TODOs: 좌표정보 직접 입력받는 알럿 띄우기
            break
            
        case .authorizedWhenInUse:
            requestLocation()
            
        case .authorizedAlways:
            break
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        @unknown default:
            break
        }
    }
}
