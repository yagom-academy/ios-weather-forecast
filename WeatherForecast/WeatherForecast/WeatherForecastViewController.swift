//
//  WeatherForecast - WeatherForecastViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherForecastViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var currentAddress: String?
    var weatherAPIManager = WeatherAPIManager()
    var currentWeather: CurrentWeather?
    var fiveDayForecast: FiveDayForecast?

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherAPIManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

}

extension WeatherForecastViewController: WeatherAPIManagerDelegate {
    func setCurrentWeather(from response: CurrentWeather) {
        self.currentWeather = response
    }
    
    func setFiveDayForecast(from response: FiveDayForecast) {
        self.fiveDayForecast = response
    }
}

extension WeatherForecastViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            guard let currentLocation = locationManager.location else {
                return
            }
            self.currentLocation = currentLocation
            placemarkToSetAddress(from: currentLocation)
            weatherAPIManager.request(information: .CurrentWeather, latitude: currentLocation.coordinate.latitude, logitude: currentLocation.coordinate.longitude)
            weatherAPIManager.request(information: .FiveDayForecast, latitude: currentLocation.coordinate.latitude, logitude: currentLocation.coordinate.longitude)
        }
    }
    
    func placemarkToSetAddress(from location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                self.setAddress(placemark)
            }
        }
    }
    
    func setAddress(_ placemark: CLPlacemark) {
        var address = ""
        if let state = placemark.administrativeArea {
            address += state
        }
        if let city = placemark.locality {
            if address != "" {
                address += " "
            }
            address += city
        }
        if let district = placemark.subLocality {
            if address != "" {
                address += " "
            }
            address += district
        }
        self.address = address
    }
}

