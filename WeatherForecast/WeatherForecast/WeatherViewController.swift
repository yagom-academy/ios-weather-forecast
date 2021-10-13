//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    private let networkManager = NetworkManager<WeatherRequest>()
    private let parsingManager = ParsingManager()
    private var locationManager = CLLocationManager()
    private var address: [CLPlacemark]? = []
    private var currentWeather: CurrentWeather? = nil {
        didSet {
            self.updateTable()
        }
    }
    
    private var fiveDayForecast: FiveDayForecast? = nil {
        didSet {
            self.updateTable()
        }
    }
    
    private lazy var weatherTableView: UITableView = {
        let weatherTableView = UITableView()
        weatherTableView.translatesAutoresizingMaskIntoConstraints = false
        weatherTableView.register(HourlyWeatherInfo.self, forCellReuseIdentifier: HourlyWeatherInfo.identifier)
        weatherTableView.register(WeatherHeaderView.self, forHeaderFooterViewReuseIdentifier: WeatherHeaderView.identifier)
        return weatherTableView
    }()
    
    private func configure() {
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
    }
    
    private func addSubView() {
        view.addSubview(weatherTableView)
    }
    
    private func updateTable() {
        DispatchQueue.main.async {
            self.weatherTableView.reloadData()
        }
    }
    
    private func requestAuthorization() {
        locationManager.requestLocation()
    }
    
    private func autoLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            weatherTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            weatherTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshWeatherTable), for: .valueChanged)
        weatherTableView.refreshControl = refreshControl
    }
    
    @objc func refreshWeatherTable(_ sender: UIRefreshControl) {
        locationManager.requestLocation()
        sender.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.startMonitoringSignificantLocationChanges()
        configure()
        addSubView()
        autoLayout()
        configureRefreshControl()
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locations = locations.last else { return }
        let latitude = locations.coordinate.latitude
        let longitude = locations.coordinate.longitude
        fetchCurrentWeather(latitude: latitude, longitude: longitude)
        fetchFiveDayForecast(latitude: latitude, longitude: longitude)
        
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geoCoder.reverseGeocodeLocation(locations, preferredLocale: locale) { placemarks, error in
            self.address = placemarks
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
}

extension WeatherViewController {
    private func fetchCurrentWeather(latitude: Double, longitude: Double) {
        networkManager.request(WeatherRequest.getCurrentWeather(latitude: latitude, longitude: longitude)) { result in
            switch result {
            case .success(let data):
                let decodedData = self.parsingManager.parse(data, to: CurrentWeather.self)
                switch decodedData {
                case .success(let modelType):
                    self.currentWeather = modelType
                case .failure(let error):
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchFiveDayForecast(latitude: Double, longitude: Double) {
        networkManager.request(WeatherRequest.getFiveDayForecast(latitude: latitude, longitude: longitude)) { result in
            switch result {
            case .success(let data):
                let decodedData = self.parsingManager.parse(data, to: FiveDayForecast.self)
                switch decodedData {
                case .success(let modelType):
                    self.fiveDayForecast = modelType
                case .failure(let error):
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fiveDayForecast?.list.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyWeatherInfo.identifier, for: indexPath) as? HourlyWeatherInfo else {
            return UITableViewCell()
        }
        cell.setUpUI(forcast: fiveDayForecast, indexPath: indexPath)
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = weatherTableView.dequeueReusableHeaderFooterView(withIdentifier: WeatherHeaderView.identifier) as? WeatherHeaderView else {
            return weatherTableView
        }
        view.setUpUI(currentWeather: currentWeather, placemark: address)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
}
