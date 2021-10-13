//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherListViewController: UIViewController {
    private var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateLocationManager()
        bringCoordinates()
    }
}

extension WeatherListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            let currentLocation = manager.location?.coordinate
            guard let currentLocation = currentLocation else { return }
            WeatherDataManager.shared.longitude = currentLocation.longitude
            WeatherDataManager.shared.latitude = currentLocation.latitude
            convertToAddress(latitude: WeatherDataManager.shared.latitude, longitude: WeatherDataManager.shared.longitude)
            WeatherDataManager.shared.fetchCurrentWeather()
            
            
        case .notDetermined, .restricted:
            manager.requestWhenInUseAuthorization()
        case .denied:
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
    }
}

extension WeatherListViewController {
    
    private func generateLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func bringCoordinates() {
           if CLLocationManager.locationServicesEnabled() {
               guard let locationManager = locationManager else { return }
               let currentCoordinate = locationManager.location?.coordinate

               locationManager.startUpdatingLocation()
               guard let lat = currentCoordinate?.latitude, let lon = currentCoordinate?.longitude else {
                   return
               }
               WeatherDataManager.shared.latitude = lat
               WeatherDataManager.shared.longitude = lon
           }
       }
    
    private func convertToAddress(latitude: Double?, longitude: Double?) {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        
        let coordinate = CLLocation(latitude: latitude, longitude: longitude)
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: "ko_kr")
        
        geoCoder.reverseGeocodeLocation(coordinate, preferredLocale: locale) { placemark, error in
            if error != nil {
                print(error)
                return
            }
            if let administrativeArea = placemark?.first?.administrativeArea {
                print(administrativeArea)
            }
            if let locality = placemark?.first?.locality {
                print(locality)
            }
        }
    }
}
