//
//  LocationManagerDelegate.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/19.
//

import UIKit.UITableViewController
import CoreLocation.CLLocationManagerDelegate

final class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let latitude = locations.last?.coordinate.latitude,
              let longitude = locations.last?.coordinate.longitude else {
            return
        }
        
        let location: Location = (latitude, longitude)
        
        if let manager = manager as? LocationManager {
            manager.lastLocation = location
        }
        
        requestWeatherData(requestPurpose: .currentWeather, location: location)
        requestWeatherData(requestPurpose: .forecast, location: location)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        if let error = error as? CLError {
            switch error.code {
            case .locationUnknown:
                break
            default:
                print(error.localizedDescription)
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .restricted, .denied:
                break
            case .authorizedWhenInUse, .authorizedAlways, .notDetermined:
                manager.requestLocation()
                break
            @unknown default: break
            }
        }
    }
}
