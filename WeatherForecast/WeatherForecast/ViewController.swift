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
        setUpRefresh()
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
    
    private func setUpRefresh() {
        let refresh: UIRefreshControl = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        refresh.tintColor = .orange
        weatherTableView.refreshControl = refresh
    }
    
    @objc func updateUI(refresh: UIRefreshControl) {
        appDelegate?.locationManager.requestLocation()
        refresh.endRefreshing()
        weatherTableView.reloadData()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocationCoordinate = locations.last?.coordinate else {
            return
        }
        appDelegate?.locationManager.stopUpdatingLocation()
        locationCoordinate.coordinate = currentLocationCoordinate
        locationCoordinate.convertToAddressWith(coordinate: currentLocationCoordinate)
        
        guard let lat = locationCoordinate.coordinate?.latitude, let lon = locationCoordinate.coordinate?.longitude else {
            return
        }
        
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
            
            guard let imageID = currentWeather?.icon[0].name else {
                return currentWeatherCell
            }
            
            WeatherForecastManager.shared.loadImage(imageID: imageID) { [self] result in
                switch result {
                case .success(let data):
                    guard let image = data else {
                        return errorHandling(error: .failGetData)
                    }
                    DispatchQueue.main.async {
                        if let index: IndexPath = tableView.indexPath(for: currentWeatherCell){
                            if index.row == indexPath.row {
                                currentWeatherCell.weatherImage.image = UIImage(data: image)
                            }
                        }
                        currentWeatherCell.cityNameLabel.text = self.locationCoordinate.address
                        if let min = self.currentWeather?.temperature.minimun, let max = self.currentWeather?.temperature.maximum {
                            currentWeatherCell.minAndMaxTemperatureLabel.text = "최저: \(min) 최고 :\(max)"
                        }
                        currentWeatherCell.averageTemperatureLabel.text = self.currentWeather?.temperature.average.description
                    }
                case .failure(let error):
                    errorHandling(error: error)
                }
            }
            
            return currentWeatherCell
        default:
            let forecastWeatherCell = weatherTableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell") as! ForecastTableViewCell
            
            guard let imageID = forecastList?.list[indexPath.row].weatehrIcon[0].name else {
                return forecastWeatherCell
            }
            WeatherForecastManager.shared.loadImage(imageID: imageID) { [self] result in
                switch result {
                case .success(let data):
                    guard let image = data else {
                        return errorHandling(error: .failGetData)
                    }
                    DispatchQueue.main.async {
                        if let index: IndexPath = tableView.indexPath(for: forecastWeatherCell){
                            if index.row == indexPath.row {
                                forecastWeatherCell.weatherImage.image = UIImage(data: image)
                            }
                        }
                    }
                case .failure(let error):
                    errorHandling(error: error)
                }
            }
            
            if let dateTime = self.forecastList?.list[indexPath.row].dateTime {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                if let date = formatter.date(from: dateTime) {
                    formatter.locale = Locale(identifier: "ko")
                    formatter.dateFormat = "MM/dd(E) HH시"
                    let dateTimeString = formatter.string(from: date)
                    forecastWeatherCell.timeDateLabel.text = dateTimeString
                }
            }
            if let avergateTemperature = self.forecastList?.list[indexPath.row].temperature.average {
                forecastWeatherCell.averageTemperatureLabel.text = String(avergateTemperature)
            }
            
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
