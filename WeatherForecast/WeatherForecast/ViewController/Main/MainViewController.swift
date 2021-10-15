//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class MainViewController: UIViewController {
    private let locationManager = LocationManager()
    private let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            forName: LocationManager.locationUpdated,
            object: nil,
            queue: .main,
            using: utilizeLocation
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.requestLocation()
    }
    
    private func utilizeLocation(_ notification: Notification) {
        guard let location = notification.object as? CLLocation else {
                  return
              }
        let coordinate = location.coordinate
        convertToAddress(location: location)
        requestDailyWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
        requestWeeklyWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    private func requestDailyWeather(latitude: Double, longitude: Double) {
        networkManager.request(
            endpoint: .daily,
            parameters: ["lat": latitude, "lon": longitude]
        ) { (result: Result<TodayWeatherInfo, Error>) in
            switch result {
            case .success:
                print("daily success")
            case .failure:
                print("daily failure")
            }
        }
    }
    
    private func requestWeeklyWeather(latitude: Double, longitude: Double) {
        networkManager.request(
            endpoint: .weekly,
            parameters: ["lat": latitude, "lon": longitude]
        ) { (result: Result<WeeklyWeatherForecast, Error>) in
            switch result {
            case .success:
                print("weekly success")
            case .failure:
                print("weekly failure")
            }
        }
    }
    
    private func convertToAddress(location: CLLocation) {
        locationManager.convertToAddress(from: location) { placemarks, error in
            print(placemarks)
        }
    }
}
