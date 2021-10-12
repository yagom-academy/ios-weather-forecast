//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    let locationManager = LocationManager()
    let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        NotificationCenter.default.addObserver(
            forName: LocationManager.locationUpdated,
            object: nil,
            queue: .main
        ) { notification in
            guard let locations = notification.object as? [CLLocation],
                  let location = locations.last else {
                return
            }
            let coordinate = location.coordinate

            self.locationManager.convertToAddress(from: location) { placeMarks, error in
                print(placeMarks)
            }

            self.networkManager.request(
                endpoint: .daily,
                parameters: ["lat": coordinate.latitude, "lon": coordinate.longitude]
            ) { (result: Result<TodayWeatherInfo, Error>) in
                switch result {
                case .success:
                    print("daily success")
                case .failure:
                    print("daily failure")
                }
            }

            self.networkManager.request(
                endpoint: .weekly,
                parameters: ["lat": coordinate.latitude, "lon": coordinate.longitude]
            ) { (result: Result<WeeklyWeatherForecast, Error>) in
                switch result {
                case .success:
                    print("weekly success")
                case .failure:
                    print("weekly failure")
                }
            }
        }
        
        locationManager.requestLocation()
    }
}
