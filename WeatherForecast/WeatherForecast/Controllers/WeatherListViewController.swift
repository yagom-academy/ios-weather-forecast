//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherListViewController: UIViewController {
    private var locationManager = CLLocationManager()
    private var address: String?
    
    private lazy var refreshControl: UIRefreshControl = { [weak self] in
        let control = UIRefreshControl()
        control.tintColor = self?.view.tintColor
        return control
    }()
    
    private var weatherListTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .white
        tableView.register(IntervalWeatherTableViewCell.self, forCellReuseIdentifier: IntervalWeatherTableViewCell.identifier)
        tableView.register(CurrentWeatherHeaderView.self, forHeaderFooterViewReuseIdentifier: CurrentWeatherHeaderView.identifier)
        
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named: "background")
        tableView.backgroundView = backgroundImageView
        backgroundImageView.alpha = 0.9
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocationManager()
        bringCoordinates()
        configureTableView()
        designateTableViewDataSourceDelegate()
        setRefreshControl()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.changeCoordinateAlert, object: nil, queue: .main) { _ in
            self.presentAlert()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.fetchFailedAlert, object: nil, queue: .main) { noti in
            guard let errorMessage = noti.userInfo?["fetchFailedMessage"] as? String else { return }
            self.showAlert(message: errorMessage)
        }
    }
}

extension WeatherListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeatherDataManager.shared.fiveDaysWeatherData?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IntervalWeatherTableViewCell.identifier, for: indexPath) as? IntervalWeatherTableViewCell else { return UITableViewCell() }
        if let fiveDaysWeatherData = WeatherDataManager.shared.fiveDaysWeatherData {
            cell.cellConfiguration(data: fiveDaysWeatherData, indexPath: indexPath)
        }
        return cell
    }
}

extension WeatherListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CurrentWeatherHeaderView.identifier) as? CurrentWeatherHeaderView else {
            return UIView()
        }
        if let unWrappedCurrentWeatherData = WeatherDataManager.shared.currentWeatherData, let address = address {
            headerView.configurationHeaderView(data: unWrappedCurrentWeatherData, address: address)
            headerView.tintColor = .clear
            
        }
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
            convertToAddress(latitude: WeatherDataManager.shared.latitude, longitude: WeatherDataManager.shared.longitude) { area, local in
                self.address = area + local
            }
            DispatchQueue.global().async {
                WeatherDataManager.shared.fetchWeatherDatas(location: CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)) {
                    DispatchQueue.main.async {
                        self.weatherListTableView.reloadData()
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.reloadHeaderView(location: location)
            self.weatherListTableView.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
extension WeatherListViewController {
    
    private func reloadHeaderView(location: CLLocation) {
        let headerView = weatherListTableView.headerView(forSection: 0) as? CurrentWeatherHeaderView
        
        convertToAddress(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { area, local in
            self.address = area + local
        }
        
        guard let address = address else { return }
        WeatherDataManager.shared.fetchCurrentWeather(location: location) { result in
            switch result {
            case .success(let currentWeatherData):
                DispatchQueue.main.async {
                    headerView?.configurationHeaderView(data: currentWeatherData, address: address)
                }
            case .failure(let error):
                NotificationCenter.default.post(name: NSNotification.Name.fetchFailedAlert, object: nil, userInfo: ["fetchFailedMessage" : "\(error.localizedDescription)의 이유로 데이터를 가져올 수 없습니다. 네트워크 연결을 확인 후 다시 시도해주세요."])
            }
        }
    }
    
    private func presentAlert() {
        let alert = UIAlertController(title: HeaderViewAlertResource.alertTitle.rawValue, message: HeaderViewAlertResource.alertMessage.rawValue, preferredStyle: .alert)
        let coordinateChangeButton = UIAlertAction(title: HeaderViewAlertResource.changeButton.rawValue, style: .default) { [weak self, weak alert] _ in
            guard let self = self, let alert = alert else { return }
            guard let latitudeString = alert.textFields?.first?.text,
                  let latitude = Double(latitudeString),
                  let longitudeString = alert.textFields?[1].text,
                  let longitude = Double(longitudeString) else { return }
            self.locationManager(self.locationManager, didUpdateLocations: [CLLocation(latitude: latitude, longitude: longitude)])
            
        }
        let resetByCurrentCoorinateButton = UIAlertAction(title: HeaderViewAlertResource.resetCurrentCoordinateButton.rawValue, style: .default) { [weak self] _ in
            guard let self = self else { return }
            guard let latitude = WeatherDataManager.shared.latitude, let longitude = WeatherDataManager.shared.longitude else { return }
            self.locationManager(self.locationManager, didUpdateLocations: [CLLocation(latitude: latitude, longitude: longitude)])
            
            
        }
        let cancelButton = UIAlertAction(title: HeaderViewAlertResource.cancelButton.rawValue, style: .cancel, handler: nil)
        alert.addTextField { textField in
            textField.placeholder = "위도"
        }
        alert.addTextField { textField in
            textField.placeholder = "경도"
        }
        alert.addAction(coordinateChangeButton)
        alert.addAction(resetByCurrentCoorinateButton)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func refresh() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            guard let currentLocation = self.locationManager.location?.coordinate else { return }
            
            WeatherDataManager.shared.fetchWeatherDatas(location: CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)) {
                self.reloadHeaderView(location: CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude))
                self.weatherListTableView.reloadData()
            }
            
            DispatchQueue.main.async {
                self.weatherListTableView.reloadData()
                self.weatherListTableView.refreshControl?.endRefreshing()
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
    
    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func bringCoordinates() {
        if CLLocationManager.locationServicesEnabled() {
            let currentCoordinate = locationManager.location?.coordinate
            
            locationManager.startUpdatingLocation()
            guard let lat = currentCoordinate?.latitude, let lon = currentCoordinate?.longitude else {
                return
            }
            WeatherDataManager.shared.latitude = lat
            WeatherDataManager.shared.longitude = lon
        }
    }
    
    private func convertToAddress(latitude: Double?, longitude: Double?, completion: @escaping (String, String) -> ()) {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        
        let coordinate = CLLocation(latitude: latitude, longitude: longitude)
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: "ko_kr")
        
        geoCoder.reverseGeocodeLocation(coordinate, preferredLocale: locale) { placemark, error in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            if let administrativeArea = placemark?.first?.administrativeArea, let locality = placemark?.first?.locality {
                completion(administrativeArea, locality)
            }
        }
    }
}

