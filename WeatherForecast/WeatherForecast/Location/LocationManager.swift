//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by kjs on 2021/10/12.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    static let locationUpdated = NSNotification.Name(rawValue: "locationUpdated")
    private let coreLocation = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    override init() {
        super.init()
        
        coreLocation.delegate = self
        coreLocation.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        coreLocation.requestLocation()
    }
    
    func convertToAddress(
        from location: CLLocation,
        completionHandler: @escaping ([CLPlacemark]?, Error?) -> Void
    ) {
        geocoder.reverseGeocodeLocation(
            location,
            preferredLocale: .current,
            completionHandler: completionHandler
        )
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
          requestLocation()
        default:
        // TODO: - 권한에 획득 실패에 따른 분기 처리 언젠가는 해야함
         print("권한 획득 실패")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NotificationCenter.default.post(name: Self.locationUpdated, object: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: - 좌표 획득 실패에 따른 분기 처리 언젠가는 해야함
    }
}
