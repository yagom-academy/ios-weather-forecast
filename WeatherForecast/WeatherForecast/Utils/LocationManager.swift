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
        var status: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            status = manager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return location
        default:
            return nil
        }
    }
    
    func getAddress(of location: CLLocation?,
                    completionHandler: @escaping (Result<[Address:String?], Error>) -> Void)
    {
        guard let validLocation = location else { return }
        
        let converter = CLGeocoder()
        converter.reverseGeocodeLocation(validLocation, preferredLocale: .current) { (placemarks, error) in
            if let error = error {
                completionHandler(.failure(error))
            }
            
            let placemark = placemarks?.first
            let address: [Address:String?] = [
                .city: placemark?.administrativeArea,
                .street1: placemark?.locality,
                .street2: placemark?.thoroughfare
            ]
            
            completionHandler(.success(address))
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
