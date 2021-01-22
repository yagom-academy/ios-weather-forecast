//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if let coordinate = locationManager.location?.coordinate {
            let openWeather = OpenWeather()
            openWeather.currentWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
            openWeather.forecastWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
}
