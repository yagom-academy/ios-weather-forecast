//
//  WeatherForecast
//  ViewController.swift
//
//  Created by Kyungmin Lee on 2021/01/22.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    // MARK: - Properties
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        return locationManager
    }()

    private var currentCoordinate: CLLocationCoordinate2D!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestCurrentCoordinate()
    }
    
    // MARK: - Methods
    private func requestCurrentCoordinate() {
        locationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate Methods
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentCoordinate = locations.last?.coordinate {
            locationManager.stopUpdatingLocation()
            self.currentCoordinate = currentCoordinate
        }
    }
}
