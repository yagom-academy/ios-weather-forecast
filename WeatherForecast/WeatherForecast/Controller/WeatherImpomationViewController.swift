//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherImpormationViewController: UIViewController {
    private let locationManager = LocationManager()
    private let apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        processWeatherNetworking()
        
    }
    private func processWeatherNetworking() {
        locationManager.getUserLocation { [weak self] location in
            guard let self = self else { return }
            let url = WeatherURL.forecastCoordinates(latitude: location.coordinate.latitude,
                                                     longitude: location.coordinate.longitude)
            self.getWeatherImpormation(request: url)
        }
    }
    
    private func getWeatherImpormation(request: UrlGeneratable) {
        self.apiManager.requestAPI(resource: APIResource(apiURL: request)) { result in
            dump(result)
        }
    }
}
