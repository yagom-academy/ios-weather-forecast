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
    private var debounceWorkItem: DispatchWorkItem?
    
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
        
        debounceWorkItem?.cancel()
        let requestWorkItem = DispatchWorkItem { [weak self] in
            guard let this = self else { return }
            this.completionHanler?(currentLocation.coordinate)
        }
        
        debounceWorkItem = requestWorkItem
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3, execute: requestWorkItem)
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODOs: 좌표정보 직접 입력받거나 현재 위치 재설정 알럿 띄우기
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            requestLocation()
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        @unknown default:
            break
        }
    }
}
