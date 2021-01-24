//
//  WeatherListViewController.swift
//  WeatherForecast
//
//  Created by 김지혜 on 2021/01/22.
//

import UIKit

class WeatherListViewController: UIViewController {
    private var fivedaysForecastWeathers: [Weather] = [] {
        didSet {
            print(fivedaysForecastWeathers)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setUp), name: Notification.Name.locationUpdate, object: nil)
        LocationManager.shared.updateLocation()
    }
}

extension WeatherListViewController {
    @objc private func setUp() {
        guard let coordinate = LocationManager.shared.locationCoordinate else { return }
        LocationManager.shared.getLocalizationString(in: "Ko-kr") { (locationString) in
            print(locationString)
        }
        WeatherManager.shared.getCurrentWeather(of: coordinate) { [weak self] (weather) in
            DispatchQueue.main.async {
                self?.setCurrentWeather(weather)
            }
        }
        
        WeatherManager.shared.getFivedaysForecastWeathers(of: coordinate) {
            self.fivedaysForecastWeathers = $0
        }
    }
    
    private func setCurrentWeather(_ weather: Weather) {
        print(weather)
    }
}
