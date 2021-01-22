//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var currentAddress = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        currentLocationUpdate()
//        if let coordinate = locationManager.location?.coordinate {
//            let openWeather = OpenWeather()
//            openWeather.currentWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
//            openWeather.forecastWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
//        })
    }
    
    func currentLocationUpdate() {
        if let location = locationManager.location {
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemark = placemarks {
                    
                    if let country = placemark[0].country {
                        self.currentAddress = country + " "
                    }

                    if let city = placemark[0].administrativeArea {
                        self.currentAddress += city + " "
                    }

                    if let locality = placemark[0].locality {
                        self.currentAddress += locality + " "
                    }

                    if let name = placemark[0].name {
                        self.currentAddress += name
                    }
                    
                    print("실행")
                }
            }
        }
    }
}
