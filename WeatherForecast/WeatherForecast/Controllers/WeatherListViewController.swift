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
    private var area: String?
    private var local: String?
    
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
        NotificationCenter.default.addObserver(forName: NSNotification.Name("alert"), object: nil, queue: .main) { _ in
            self.presentAlert()
        }
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
        return WeatherDataManager.shared.fiveDaysWeatherData?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        if let unWrappedFiveDaysWeatherData = WeatherDataManager.shared.fiveDaysWeatherData {
            let daysWeatherData = unWrappedFiveDaysWeatherData.list[indexPath.row]
            let date = daysWeatherData.timeOfDataText
//            let formattedDateString = "\(dateFormatter.string(from: date))시"
            let minTemperature = "\(daysWeatherData.mainInfo.temperatureMin)º"
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
        if let unWrappedCurrentWeatherData = WeatherDataManager.shared.currentWeatherData, let area = area, let local = local {
            let address = area + local
            let minMaxTemperature = "최저\(String(format: "%.1f", unWrappedCurrentWeatherData.mainInfo.temperatureMin))º 최고\(String(format: "%.1f",unWrappedCurrentWeatherData.mainInfo.temperatureMax))º"
            let currentTemperature = "\(unWrappedCurrentWeatherData.mainInfo.temperature)º"
            headerView.configurationHeaderView(address: address, minMaxTemperature: minMaxTemperature, currentTemperature: currentTemperature)
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
            convertToAddress(latitude: WeatherDataManager.shared.latitude, longitude: WeatherDataManager.shared.longitude) { area, local in
                self.area = area
                self.local = local
            }
            
            WeatherDataManager.shared.fetchWeatherDatas(location: CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)) {
                self.weatherListTableView.reloadData()
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
    private func presentAlert() {
        let alert = UIAlertController(title: AlertResource.alertTitle.rawValue, message: AlertResource.alertMessage.rawValue, preferredStyle: .alert)
        let coordinateChangeButton = UIAlertAction(title: AlertResource.changeButton.rawValue, style: .default) { [weak self] _ in
            guard let latitudeString = alert.textFields?.first?.text,
                  let latitude = Double(latitudeString),
                  let longitudeString = alert.textFields?[1].text,
                  let longitude = Double(longitudeString) else { return }

            WeatherDataManager.shared.fetchWeatherDatas(location: CLLocation(latitude: latitude, longitude: longitude)) {
                self?.weatherListTableView.reloadData()
            }
            
        }
        let resetByCurrentCoorinateButton = UIAlertAction(title: AlertResource.resetCurrentCoordinateButton.rawValue, style: .default) { [weak self] _ in
            guard let latitude = WeatherDataManager.shared.latitude, let longitude = WeatherDataManager.shared.longitude else { return }
            
            WeatherDataManager.shared.fetchWeatherDatas(location: CLLocation(latitude: latitude, longitude: longitude)) {
                self?.weatherListTableView.reloadData()
            }
        }
        let cancelButton = UIAlertAction(title: AlertResource.cancelButton.rawValue, style: .cancel, handler: nil)
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
           
            guard let currentLocation = self?.locationManager?.location?.coordinate else { return }
            
            WeatherDataManager.shared.fetchWeatherDatas(location: CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)) {
                self?.weatherListTableView.reloadData()
            }
       
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
    
    private func convertToAddress(latitude: Double?, longitude: Double?, completion: @escaping (String, String) -> ()) {
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
            if let administrativeArea = placemark?.first?.administrativeArea, let locality = placemark?.first?.locality {
                completion(administrativeArea, locality)
            }

        }
    }
}
