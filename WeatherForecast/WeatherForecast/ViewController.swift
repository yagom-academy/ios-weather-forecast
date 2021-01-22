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
//            openWeather.currentWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
//            openWeather.forecastWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
//            Thread.sleep(forTimeInterval: 3)
        }
        
        currentLocation()
    }
    
    func currentLocation() {
        if let location = locationManager.location {
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemark = placemarks {
                    print("location: \(placemark[0].location)")
                    print("name: \(placemark[0].name)")
                    print("country: \(placemark[0].country)")
                }
            }
        }
    }
}
