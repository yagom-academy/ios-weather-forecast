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
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let networkManager = NetworkManager()

        guard let longitude = manager.location?.coordinate.longitude,
              let latitude = manager.location?.coordinate.latitude,
              let url = URL(string: "http://api.openweathermap.org/data/2.5/weather") else  {
            return
        }
        
        let requestInfo: Parameters = ["lat": latitude, "lon": longitude, "appid": networkManager.apiKey]
        
        let weatherApi = WeatherApi(httpTask: .request(withUrlParameters: requestInfo), httpMethod: .get, baseUrl: url)
        
        networkManager.getCurrentWeatherData(weatherAPI: weatherApi, URLSession.shared)
    }
}

