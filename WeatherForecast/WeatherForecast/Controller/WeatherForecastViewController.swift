//
//  WeatherForecast - WeatherForecastViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherForecastViewController: UIViewController {
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundView = UIImageView(image: UIImage(named: "tokyo_tower.jpeg"))
        tableView.backgroundView?.alpha = 0.8
        tableView.register(WeatherForecastViewCell.self, forCellReuseIdentifier: WeatherForecastViewCell.identifier)
        tableView.separatorColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let locationSetter: UIButton = {
        let locationSetter = UIButton()
        locationSetter.setTitleColor(.white, for: .normal)
        locationSetter.backgroundColor = .clear
        locationSetter.translatesAutoresizingMaskIntoConstraints = false
        return locationSetter
    }()

    private var tableHeaderView: WeatherForecastHeaderView!
    private var locationManager = LocationManager()
    private var networkManager = NetworkManager()
    private var currentData: CurrentWeather?
    private var forecastData: [ForecastWeather.List] = []
    private var settingLocation: CLLocationCoordinate2D?
    private var alert: [UIAlertController] = []
    private let groupForFetch = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        setUpTableViewLayout()
        setUpConstraints()
        configureAlertControl()
        configureRefreshControl()
        // Do any additional setup after loading the view.
    }

    private func setUpTableViewLayout() {
        tableHeaderView = WeatherForecastHeaderView(frame:
                                                    CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height * 0.15))
        tableHeaderView.addSubview(locationSetter)
        tableView.tableHeaderView = tableHeaderView
        tableView.rowHeight = view.frame.height / 15
        view.addSubview(tableView)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.topAnchor),
                                     tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     locationSetter.topAnchor.constraint(equalTo: tableHeaderView.topAnchor, constant: 8),
                                     locationSetter.trailingAnchor.constraint(equalTo: tableHeaderView.trailingAnchor, constant: -16)])
    }

    private func configureAlertControl() {
        let alertAllow = AlertController.createAlertToGetCoordinate(title: "위치 변경", message: "변경할 좌표를 선택해주세요")
        let alertReject = AlertController.createAlertToGetCoordinate(title: "위치변경", message: "날씨를 받아올 위치의 위도와 경도를 입력해주세요")

        let alertAllowChangeAction = UIAlertAction(title: "변경", style: .default) { [weak self] _ in
            guard let self = self else { return }
            guard let textFields = alertAllow.textFields else { return }
            guard let lat = CLLocationDegrees(textFields.first?.text ?? ""),
                  let lon = CLLocationDegrees(textFields.last?.text ?? "") else { return }

            self.settingLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            if let settingLocation = self.settingLocation {
                self.fetchingWeatherData(coordinate: settingLocation, api: WeatherAPI.current, type: CurrentWeather.self)
                self.fetchingWeatherData(coordinate: settingLocation, api: WeatherAPI.forecast, type: ForecastWeather.self)
                self.groupForFetch.notify(queue: DispatchQueue.main) {
                    self.tableView.reloadData()
                }
            }
        }

        let alertRejectChangeAction = UIAlertAction(title: "변경", style: .default) { [weak self] _ in
            guard let self = self else { return }
            guard let textFields = alertReject.textFields else { return }
            guard let lat = CLLocationDegrees(textFields.first?.text ?? ""),
                  let lon = CLLocationDegrees(textFields.last?.text ?? "") else { return }

            self.settingLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            if let settingLocation = self.settingLocation {
                self.fetchingWeatherData(coordinate: settingLocation, api: WeatherAPI.current, type: CurrentWeather.self)
                self.fetchingWeatherData(coordinate: settingLocation, api: WeatherAPI.forecast, type: ForecastWeather.self)
                self.groupForFetch.notify(queue: DispatchQueue.main) {
                    self.tableView.reloadData()
                }
            }
        }

        let alertResetAction = UIAlertAction(title: "현재 위치로 재설정", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.settingLocation = nil
            self.locationManager.requestLocation()
        }

        let alertCancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertAllow.addActions(alertAllowChangeAction, alertResetAction, alertCancelAction)
        alertReject.addActions(alertRejectChangeAction, alertCancelAction)

        alert.append(alertAllow)
        alert.append(alertReject)
    }

    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .orange
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    @objc func touchUpAllowAlert() {
        self.present(alert[0], animated: true, completion: nil)
    }

    @objc func touchUpRejectAlert() {
        self.present(alert[1], animated: true, completion: nil)
    }

    @objc func handleRefreshControl() {
        if let settingLocation = settingLocation {
            fetchingWeatherData(coordinate: settingLocation, api: WeatherAPI.current, type: CurrentWeather.self)
            fetchingWeatherData(coordinate: settingLocation, api: WeatherAPI.forecast, type: ForecastWeather.self)
        } else if locationManager.isAuthorizationAllowed() {
            locationManager.requestLocation()
        } else {
            self.present(alert[1], animated: true) {
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
        }

        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: UITableViewDataSource 구현부
extension WeatherForecastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherForecastViewCell.identifier, for: indexPath) as? WeatherForecastViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(data: forecastData[indexPath.row])
        return cell
    }
}

// MARK: LocationManagerDelegate 구현부
extension WeatherForecastViewController: LocationManagerDelegate {
    func didUpdateLocation() {
        self.settingLocation = nil
        guard let coordinate = locationManager.getCoordinate() else { return }
        fetchingWeatherData(coordinate: coordinate, api: WeatherAPI.current, type: CurrentWeather.self)
        fetchingWeatherData(coordinate: coordinate, api: WeatherAPI.forecast, type: ForecastWeather.self)
        groupForFetch.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
        }
    }

    func authorizationRejected() {
        DispatchQueue.main.async {
            self.locationSetter.setTitle("위치변경", for: .normal)
            self.locationSetter.removeTarget(nil, action: nil, for: .allEvents)
            self.locationSetter.addTarget(self, action: #selector(self.touchUpRejectAlert), for: .touchUpInside)
        }
        self.present(alert[1], animated: true, completion: nil)
    }

    func authorizationAllowed() {
        DispatchQueue.main.async {
            self.locationSetter.setTitle("위치설정", for: .normal)
            self.locationSetter.removeTarget(nil, action: nil, for: .allEvents)
            self.locationSetter.addTarget(self, action: #selector(self.touchUpAllowAlert), for: .touchUpInside)
        }
        locationManager.requestLocation()
    }

    private func fetchingWeatherData<T: Decodable>(coordinate: CLLocationCoordinate2D, api: WeatherAPI, type: T.Type) {
        let queryItems = [CoordinatesQuery.lat: String(coordinate.latitude),
                          CoordinatesQuery.lon: String(coordinate.longitude),
                          CoordinatesQuery.appid: "e6f23abdc0e7e9080761a3cfbbdafc90"]

        guard let url = URL.createURL(API: api, queryItems: queryItems) else { return }
        groupForFetch.enter()
        networkManager.dataTask(url: url) { [weak self] result in
            guard let self = self else { return }
            if case .success(let data) = result {
                do {
                    let data = try JSONDecoder().decode(type, from: data)
                    if let data = data as? CurrentWeather {
                        self.currentData = data
                        self.configureHeader(data: data)
                    } else if let data = data as? ForecastWeather {
                        self.forecastData = data.list
                    }
                } catch {
                    debugPrint(error)
                }
            }
            self.groupForFetch.leave()
        }
    }

    private func configureHeader(data: CurrentWeather) {
        let targetLocation = CLLocation(coordinate: data.coordinate)
        locationManager.getAddress(location: targetLocation) { result in
            switch result {
            case .success(let placemark):
                self.tableHeaderView.configure(data: data, placemark: placemark)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}

// MARK: UITableViewDelegate
extension WeatherForecastViewController: UITableViewDelegate {}
