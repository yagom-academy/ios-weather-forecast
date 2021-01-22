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
            requestAddress(of: currentLocation) { (currentAddress) in
                self.currentAddress = currentAddress
            }
            weatherAPIManager.request(information: .currentWeather, latitude: currentLocation.coordinate.latitude, logitude: currentLocation.coordinate.longitude)
            weatherAPIManager.request(information: .fiveDayForecast, latitude: currentLocation.coordinate.latitude, logitude: currentLocation.coordinate.longitude)
        }
    }
    
    func requestAddress(of location: CLLocation, _ completionHandler: @escaping (String) -> Void ) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                let currentAddress = self.address(from: placemark)
                completionHandler(currentAddress)
            }
        }
    }
    
    func address(from placemark: CLPlacemark) -> String {
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
        return address
    }
}

