//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

extension Notification.Name {
    static let refreshLocation = Notification.Name("refreshLocation")
}

class WeatherViewController: UIViewController {
    private var currentCoordinate: Coordinate?
    private var currentWeather: TodayWeatherInfo?
    private var weatherForecast: WeeklyWeatherForecast?
    
    private let locationManager = WeatherLocationManager()
    private let networkManager = NetworkManager()
    
    private let weatherView = WeatherView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = weatherView
        locationManager.delegate = self
        locationManager.requestLocation()
        weatherView.forecastTableView.dataSource = self
        weatherView.forecastTableView.delegate = self
        weatherView.forecastTableView.register(
            WeatherTableHeaderView.self,
            forHeaderFooterViewReuseIdentifier: WeatherTableHeaderView.reuseIdentifier
        )
        weatherView.forecastTableView.register(
            WeatherTableViewCell.self,
            forCellReuseIdentifier: WeatherTableViewCell.reuseIdentifier
        )
        configureRefreshControl()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveRefreshFinish), name: .refreshLocation, object: nil)
    }
}

// MARK: - TableViewDataSource, TableViewDelegate
extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: WeatherTableHeaderView.reuseIdentifier
        ) as? WeatherTableHeaderView
        else { fatalError() }
        
        currentWeather.flatMap { header.configure(with: $0) }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WeatherTableViewCell.reuseIdentifier)
                as? WeatherTableViewCell
        else { fatalError() }
        
        weatherForecast?.list.flatMap {
            cell.configure(with: $0[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherForecast?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            break
        case .restricted, .denied:
            showAlert(title: "위치 서비스 제공이 불가능합니다.",
                      message: "어플리케이션 설정에서 위치 권한을 허용해주세요.")
        default:
            showAlert(title: "위치 서비스 제공이 불가능합니다.",
                      message: "개발자에게 신고해주세요.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last
        else { return }
        currentCoordinate = Coordinate(longitude: location.coordinate.longitude,
                                           latitude: location.coordinate.latitude)
        let group = DispatchGroup()
        currentCoordinate.flatMap { coord in
            group.enter()
                networkManager.request(
                    with: TodayWeatherInfo.self,
                    parameters: coord.parameters
                ) { [weak self] result in
                    switch result {
                    case .success(let model):
                        self?.currentWeather = model
                    case .failure(let error):
                        print(error)
                    }
                    group.leave()
                }
            group.enter()
                networkManager.request(
                    with: WeeklyWeatherForecast.self,
                    parameters: coord.parameters
                ) { [weak self] result in
                    switch result {
                    case .success(let model):
                        self?.weatherForecast = model
                    case .failure(let error):
                        print(error)
                    }
                    group.leave()
                }
        }
        group.wait()
        DispatchQueue.main.async {
            self.weatherView.forecastTableView.reloadData()
        }
        NotificationCenter.default.post(name: NSNotification.Name.refreshLocation, object: nil)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { }
}

extension WeatherViewController {
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert)
            
            let okAction = UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Refresh Control
extension WeatherViewController {
    func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "날씨 업데이트 중")
        weatherView.forecastTableView.refreshControl = refreshControl
        weatherView.forecastTableView.refreshControl?.addTarget(
            self,
            action: #selector(handleRefreshControl),
            for: .valueChanged
        )
    }
    
    @objc func handleRefreshControl() {
        self.locationManager.requestLocation()
    }
    
    @objc func didReceiveRefreshFinish() {
        DispatchQueue.main.async {
            self.weatherView.forecastTableView.refreshControl?.endRefreshing()
        }
    }
}
