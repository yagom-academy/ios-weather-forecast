//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/12.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    private var locationCompletion: ((CLLocation) -> Void)?
    private var currentLocation: CLLocation?
    
    func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.locationCompletion = completion
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func getUserAddress(completion: @escaping (Result<String, LocationError>) -> Void) {
        let locale = Locale(identifier: "ko-kr")
        guard let currentLocation = currentLocation else { return }
        CLGeocoder().reverseGeocodeLocation(currentLocation,
                                            preferredLocale: locale) { placemarks, error in
            if let error = error {
                completion(.failure(.unknown(description: error.localizedDescription)))
                return
            }
            
            guard let placemarks = placemarks?.last else {
                completion(.failure(.invalidPlacemarks))
                return
            }
            
            guard let administrativeArea = placemarks.administrativeArea,
                  let thororoughfare = placemarks.thoroughfare else {
                      completion(.failure(.inalidAddress))
                      return
                  }
            
            let currentAddress = "\(administrativeArea) \(thororoughfare)"
            completion(.success(currentAddress))
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        locationCompletion?(location)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
}
