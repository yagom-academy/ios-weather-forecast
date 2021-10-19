//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class OpenWeatherMainViewController: UIViewController {
    private let tableViewController = TableViewController()
    
    private let locationManager = LocationManager()
    private let locationManagerDelegate = LocationManagerDelegate()

    //MARK: - View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewController()
        locationManager.delegate = locationManagerDelegate
        locationManager.askUserLocation()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadView),
                                               name: .reloadView,
                                               object: nil)
    }
    
    @objc func reloadView() {
        self.locationManager.requestLocation()
    }
    
    private func addViewController() {
        add(tableViewController)
        self.view.addSubview(tableViewController.view)
        tableViewController.view.frame = self.view.bounds
    }
}
