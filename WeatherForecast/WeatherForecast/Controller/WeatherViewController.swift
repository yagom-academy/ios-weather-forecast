//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation
class WeatherViewController: UIViewController {
    
    private var locationManager = LocationManager()
    private var currentData: CurrentWeather?
    private var forecastData: ForecastWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
}

extension WeatherViewController: LocationManagerDelegate {
    func didUpdateLocation(_ location: CLLocation) {
        fetchingWeatherData(api: WeatherAPI.current, type: CurrentWeather.self)
        fetchingWeatherData(api: WeatherAPI.forecast, type: ForecastWeather.self)
    }
    
    func fetchingWeatherData<T: Decodable>(api: WeatherAPI, type: T.Type) {
        guard let coordinate = locationManager.getCoordinate() else {
            return
        }
        
        let networkManager = NetworkManager()
        let queryItems = [CoordinatesQuery.lat: String(coordinate.latitude),
                          CoordinatesQuery.lon: String(coordinate.longitude),
                          CoordinatesQuery.appid: "e6f23abdc0e7e9080761a3cfbbdafc90"]
        
        guard let url = URL.createURL(API: api, queryItems: queryItems) else { return }
        networkManager.dataTask(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(type, from: data)
                    
                } catch {

                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
