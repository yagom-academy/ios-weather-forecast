//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherListViewController: UIViewController {
    private var locationManager: CLLocationManager?
    private var currentWeatherData: CurrentWeather?
    private var fiveDaysWeatherData: FivedaysWeather?
    
    private lazy var refreshControl: UIRefreshControl = { [weak self] in
        let control = UIRefreshControl()
        control.tintColor = self?.view.tintColor
        return control
    }()
    
    private var weatherListTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: CustomHeaderView.identifier)
        
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named: "background")
        tableView.backgroundView = backgroundImageView
        backgroundImageView.alpha = 0.9
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateLocationManager()
        bringCoordinates()
        configureTableView()
        designateTableViewDataSourceDelegate()
        setRefreshControl()
        
        
    }
}

extension WeatherListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fiveDaysWeatherData?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        cell.dateLabel.text = "2200-00-11"
        cell.mininumTemperatureLabel.text = "4.0"
        cell.weatherImageView.image = UIImage(named: "background")
        return cell
    }
}

extension WeatherListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeaderView.identifier) as? CustomHeaderView else {
            return UIView()
        }
        headerView.tintColor = .clear
        return headerView
    }
}

extension WeatherListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            let currentLocation = manager.location?.coordinate
            guard let currentLocation = currentLocation else { return }
            WeatherDataManager.shared.longitude = currentLocation.longitude
            WeatherDataManager.shared.latitude = currentLocation.latitude
            convertToAddress(latitude: WeatherDataManager.shared.latitude, longitude: WeatherDataManager.shared.longitude)
            
            DispatchQueue.global().async {
                WeatherDataManager.shared.fetchCurrentWeather { result in
                    switch result {
                    case .success(let currentWeatherData):
                        self.currentWeatherData = currentWeatherData
                        DispatchQueue.main.async {
                            self.weatherListTableView.reloadData()
                        }
                        print(currentWeatherData)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            
            DispatchQueue.global().async {
                WeatherDataManager.shared.fetchFiveDaysWeather { result in
                    switch result {
                    case .success(let fiveDaysWeatherData):
                        self.fiveDaysWeatherData = fiveDaysWeatherData
                        DispatchQueue.main.async {
                            self.weatherListTableView.reloadData()
                        }
                        print(fiveDaysWeatherData)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            
        case .notDetermined, .restricted:
            manager.requestWhenInUseAuthorization()
        case .denied:
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
    }
}
extension WeatherListViewController {
    @objc private func refresh() {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.weatherListTableView.reloadData()
                strongSelf.weatherListTableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    private func setRefreshControl() {
        weatherListTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    private func designateTableViewDataSourceDelegate() {
        weatherListTableView.dataSource = self
        weatherListTableView.delegate = self
    }
    
    private func configureTableView() {
        view.addSubview(weatherListTableView)
        
        NSLayoutConstraint.activate([
            weatherListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            weatherListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func generateLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func bringCoordinates() {
        if CLLocationManager.locationServicesEnabled() {
            guard let locationManager = locationManager else { return }
            let currentCoordinate = locationManager.location?.coordinate
            
            locationManager.startUpdatingLocation()
            guard let lat = currentCoordinate?.latitude, let lon = currentCoordinate?.longitude else {
                return
            }
            WeatherDataManager.shared.latitude = lat
            WeatherDataManager.shared.longitude = lon
        }
    }
    
    private func convertToAddress(latitude: Double?, longitude: Double?) {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        
        let coordinate = CLLocation(latitude: latitude, longitude: longitude)
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: "ko_kr")
        
        geoCoder.reverseGeocodeLocation(coordinate, preferredLocale: locale) { placemark, error in
            if error != nil {
                print(error)
                return
            }
            if let administrativeArea = placemark?.first?.administrativeArea {
                print(administrativeArea)
            }
            if let locality = placemark?.first?.locality {
                print(locality)
            }
        }
    }
}
