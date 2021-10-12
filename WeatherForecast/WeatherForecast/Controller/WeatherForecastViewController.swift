//
//  WeatherForecast - WeatherForecastViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherForecastViewController: UIViewController {

    private var locationManager = LocationManager()
    private var networkManager = NetworkManager()
    private var currentData: CurrentWeather?
    private var forecastData: ForecastWeather?

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        // Do any additional setup after loading the view.
    }
}

extension WeatherForecastViewController: LocationManagerDelegate {
    func didUpdateLocation() {
        fetchingWeatherData(api: WeatherAPI.current, type: CurrentWeather.self)
        fetchingWeatherData(api: WeatherAPI.forecast, type: ForecastWeather.self)
    }

    private func fetchingWeatherData<T: Decodable>(api: WeatherAPI, type: T.Type) {
        guard let coordinate = locationManager.getCoordinate() else {
            return
        }

        let queryItems = [CoordinatesQuery.lat: String(coordinate.latitude),
                          CoordinatesQuery.lon: String(coordinate.longitude),
                          CoordinatesQuery.appid: "e6f23abdc0e7e9080761a3cfbbdafc90"]

        guard let url = URL.createURL(API: api, queryItems: queryItems) else { return }
        networkManager.dataTask(url: url) { [weak self] result in
            if case .success(let data) = result {
                do {
                    let data = try JSONDecoder().decode(type, from: data)
                    debugPrint(data)
                    if let data = data as? CurrentWeather {
                        self?.currentData = data
                    } else if let data = data as? ForecastWeather {
                        self?.forecastData = data
                    }
                } catch {
                    debugPrint(error)
                }
            }
        }
    }
}
