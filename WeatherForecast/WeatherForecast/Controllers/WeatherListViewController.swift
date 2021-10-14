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
    private var weatherImages: [UIImage?] = [UIImage?]()
    private var downloadTasks = [URLSessionTask]()
    
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

extension WeatherListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            downloadImage(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            cancelDownload(at: indexPath.row)
        }
    }
}

extension WeatherListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fiveDaysWeatherData?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        if let unWrappedFiveDaysWeatherData = fiveDaysWeatherData {
            let daysWeatherData = unWrappedFiveDaysWeatherData.list[indexPath.row]
            let date = daysWeatherData.timeOfDataText
            let minTemperature = "\(daysWeatherData.mainInfo.temperatureMin)℃"
            cell.cellConfiguration(date: date, minTemperature: minTemperature)
        }
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
    func generateImageURL(at index: Int) -> URL {
        let urlbuilder = URLBuilder()
        let resource = URLResource()
        guard let imageURL = urlbuilder.builderImageURL(resource: resource, index: index) else { fatalError("Invalid URL") }
        return imageURL
    }
    
    func downloadImage(at index: Int) {
        guard weatherImages[index] == nil else {
            return
        }
        let imageURL = generateImageURL(at: index)
        guard !downloadTasks.contains(where: { task in
            task.originalRequest?.url == imageURL
        }) else { return }
        
        let task = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let data = data, let image = UIImage(data: data), let strongSelf = self {
                strongSelf.weatherImages.append(image)
                let reloadIndexPath = IndexPath(row: index, section: 0)
                DispatchQueue.main.async {
                    if strongSelf.weatherListTableView.indexPathsForVisibleRows?.contains(reloadIndexPath) == .some(true) {
                        strongSelf.weatherListTableView.reloadRows(at: [reloadIndexPath], with: .automatic)
                    }
                }
                strongSelf.completeTask()
            }
            
        }
        task.resume()
        downloadTasks.append(task)
    }
    
    func completeTask() {
        downloadTasks = downloadTasks.filter({ task in
            task.state != .completed
        })
    }
    
    func cancelDownload(at index: Int) {
        let imageURL = generateImageURL(at: index)
        guard let taskIndex = downloadTasks.firstIndex(where: { $0.originalRequest?.url == imageURL }) else { return }
        let task = downloadTasks[taskIndex]
        task.cancel()
        downloadTasks.remove(at: taskIndex)
    }
    
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
