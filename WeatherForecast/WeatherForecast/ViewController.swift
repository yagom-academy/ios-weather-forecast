//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    let locationManager = CLLocationManager()
    var currentAddress = ""
    var currentWeather: CurrentWeather?
    var currentWeatherURLResponse: URLResponse?
    var currentWeatherError: Error?
    var forecastWeather: ForecastWeather?
    var forecastWeatherURLResponse: URLResponse?
    var forecastWeatherError: Error?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func currentLocationUpdate() {
        if let location = locationManager.location {
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemark = placemarks {
                    if let country = placemark.first?.country {
                        self.currentAddress = country + " "
                    }

                    if let city = placemark.first?.administrativeArea {
                        self.currentAddress += city + " "
                    }

                    if let locality = placemark.first?.locality {
                        self.currentAddress += locality + " "
                    }

                    if let name = placemark.first?.name {
                        self.currentAddress += name
                    }
                }
            }
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocationUpdate()
        
        if let coordinate = locationManager.location?.coordinate {
            let openWeather = WeatherCenter()
            openWeather.currentWeather(latitude: coordinate.latitude, longitude: coordinate.longitude) {
                data, urlResponse, error in
                self.currentWeather = data
                self.currentWeatherURLResponse = urlResponse
                self.currentWeatherError = error
            }
            openWeather.forecastWeather(latitude: coordinate.latitude, longitude: coordinate.longitude) {
                data, urlResponse, error in
                self.forecastWeather = data
                self.forecastWeatherURLResponse = urlResponse
                self.forecastWeatherError = error
            }
        }
    }
}
