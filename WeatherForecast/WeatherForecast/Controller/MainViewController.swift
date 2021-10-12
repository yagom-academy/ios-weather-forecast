//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    let locationManager = CLLocationManager(desiredAccuracy: kCLLocationAccuracyThreeKilometers)
    var currentLocation: CLLocation? {
        willSet {
            guard let newLocation = newValue else {
                return
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("\(#function) - didChangeAuthorization")
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("restricted, denied")
        default:
            print("default")
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations.count)
        guard currentLocation == nil else {
            print(currentLocation?.coordinate)
            return
        }
        print("\(#function) - didUpdateLocation")
        currentLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog(error.localizedDescription)
        locationManager.requestLocation()
    }
}
