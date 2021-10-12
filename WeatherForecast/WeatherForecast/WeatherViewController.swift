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
    private var currentWeather: CurrentWeather?
    private var fiveDayForecast: FiveDayForecast?
    private var locationManager = CLLocationManager()
    private let tableViewDatasource = WeatherInfoTable()
    
    private var weatherTableView: UITableView = {
        let weatherTableView = UITableView()
        weatherTableView.translatesAutoresizingMaskIntoConstraints = false
        weatherTableView.register(HourlyWeatherInfo.self, forCellReuseIdentifier: HourlyWeatherInfo.identifier)
        weatherTableView.register(WeatherHeaderView.self, forHeaderFooterViewReuseIdentifier: WeatherHeaderView.identifier)
        return weatherTableView
    }()
    
    private func configure() {
        weatherTableView.dataSource = tableViewDatasource
        weatherTableView.delegate = self
    }
    
    private func addSubView() {
        view.addSubview(weatherTableView)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringVisits()
        configure()
        addSubView()
        autoLayout()
    }
}


extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        let latitude = visit.coordinate.latitude
        let longitude = visit.coordinate.longitude
        fetchCurrentWeather(latitude: latitude, longitude: longitude)
        fetchFiveDayForecast(latitude: latitude, longitude: longitude)
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
            if let address = placemarks?.first {
                print(address.administrativeArea)
                print(address.locality)
            }
        }
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

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = weatherTableView.dequeueReusableHeaderFooterView(withIdentifier: WeatherHeaderView.identifier) as? WeatherHeaderView else {
             return weatherTableView
        }
        view.locationLabel.text = currentWeather?.name
        view.minMaxTemperatureLabel.text = "최저기온 4도 최고기온 3도"
        view.currentTemperatureLabel.text = "현재기온 십도"
        return view
    }
}
