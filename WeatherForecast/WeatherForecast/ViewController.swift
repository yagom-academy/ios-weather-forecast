//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private var currentWeather: CurrentWeather?
    private var forecastList: ForecastList?
    private let locationCoordinate: LocationCoordinate = LocationCoordinate()
    private let weatherTableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
        setUpTableView()
    }
    
    private func setUpTableView() {
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        self.weatherTableView.register(CurrentWeatherTableViewCell.self, forCellReuseIdentifier: "CurrentWeatherTableViewCell")
        self.weatherTableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: "ForecastTableViewCell")
        
        view.addSubview(weatherTableView)
        let safeLayoutGuide = view.safeAreaLayoutGuide
        weatherTableView.translatesAutoresizingMaskIntoConstraints = false
        weatherTableView.allowsSelection = false
        NSLayoutConstraint.activate([
            weatherTableView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            weatherTableView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpLocationManager() {
        appDelegate?.locationManager.delegate = self
        appDelegate?.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocationCoordinate = locations.last?.coordinate else {
            return
        }
        appDelegate?.locationManager.stopUpdatingLocation()
        let lat = CLLocationDegrees(CGFloat(currentLocationCoordinate.latitude))
        let lon = CLLocationDegrees(CGFloat(currentLocationCoordinate.longitude))
        
        WeatherForecastManager.shared.loadData(lat: lat, lon: lon, api: WeatherAPI.forecast) { [self] result in
            switch result {
            case .success(let data):
                guard let forecastData = data else {
                    return errorHandling(error: .failGetData)
                }
                do {
                    forecastList = try JSONDecoder().decode(ForecastList.self, from: forecastData)
                } catch {
                    errorHandling(error: .failDecode)
                }
            case .failure(let error):
                errorHandling(error: error)
            }
        }
        
        WeatherForecastManager.shared.loadData(lat: lat, lon: lon, api: WeatherAPI.current) { [self] result in
            switch result {
            case .success(let data):
                guard let currentData = data else {
                    return errorHandling(error: .failGetData)
                }
                do {
                    currentWeather = try JSONDecoder().decode(CurrentWeather.self, from: currentData)
                } catch {
                    errorHandling(error: .failDecode)
                }
            case .failure(let error):
                errorHandling(error: error)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(with: .failGetCurrentLocation)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            appDelegate?.locationManager.startUpdatingLocation()
        case .denied:
            showAuthorizationAlert(with: .failGetAuthorization)
        default:
            return
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            guard let numberOfRow = forecastList?.count else {
                return 40
            }
            return numberOfRow
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let currentWeatherCell = weatherTableView.dequeueReusableCell(withIdentifier: "CurrentWeatherTableViewCell") as! CurrentWeatherTableViewCell
            
            return currentWeatherCell
        default:
            let forecastWeatherCell = weatherTableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell") as! ForecastTableViewCell
            
            return forecastWeatherCell
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        default:
            return 50
        }
    }
}
