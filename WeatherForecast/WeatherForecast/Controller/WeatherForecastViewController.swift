//
//  WeatherForecast - WeatherForecastViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherForecastViewController: UIViewController {
    private var tableView = UITableView(frame: .zero, style: .grouped)
    private var tableHeaderView: WeatherForecastHeaderView!
    private var locationManager = LocationManager()
    private var networkManager = NetworkManager()
    private var currentData: CurrentWeather?
    private var forecastData: ForecastWeather?
    private var alert: UIAlertController!
    private let locationSetter: UIButton = {
        let button = UIButton()
        button.setTitle("위치설정", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(touchup), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        locationManager.delegate = self
        setUpTableView()
        // Do any additional setup after loading the view.
    }

    private func setUpTableView() {
        view.addSubview(tableView)
        tableHeaderView = WeatherForecastHeaderView(frame:
                            CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height * 0.15))
        tableHeaderView.addSubview(locationSetter)
        tableView.tableHeaderView = tableHeaderView
        tableView.backgroundView = UIImageView(image: UIImage(named: "tokyo_tower.jpeg"))
        tableView.backgroundView?.alpha = 0.8
        tableView.separatorColor = .white

        tableView.register(WeatherForecastViewCell.self, forCellReuseIdentifier: WeatherForecastViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.topAnchor),
                                     tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     locationSetter.topAnchor.constraint(equalTo: tableHeaderView.topAnchor, constant: 8),
                                     locationSetter.trailingAnchor.constraint(equalTo: tableHeaderView.trailingAnchor, constant: -16)
                                    ])
        configureAlertControl()
        configureRefreshControl()
    }

    
    private func configureAlertControl() {
        alert = UIAlertController(title: "위치변경", message: "변경할 좌표를 선택해주세요", preferredStyle: .alert)
        alert.addTextField { latitudeTextField in
            latitudeTextField.placeholder = "위도"
            latitudeTextField.keyboardType = .decimalPad
        }

        alert.addTextField { longitudeTextField in
            longitudeTextField.placeholder = "경도"
            longitudeTextField.keyboardType = .decimalPad
        }

        alert.addAction(UIAlertAction(title: "변경", style: .default, handler: { _ in
            guard let textFields = self.alert.textFields else {
                return
            }
            guard let lat = CLLocationDegrees(textFields.first?.text ?? ""), let lon = CLLocationDegrees(textFields.last?.text ?? "") else {
                return
            }
            let givenCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            self.fetchingWeatherData(coordinate: givenCoordinate, api: WeatherAPI.current, type: CurrentWeather.self)
            self.fetchingWeatherData(coordinate: givenCoordinate, api: WeatherAPI.forecast, type: ForecastWeather.self)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "현재 위치로 재설정", style: .default, handler: { _ in
            self.locationManager.requestLocation()
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    }

    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .orange
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    @objc func touchup() {
        self.present(alert, animated: true, completion: nil)
    }

    @objc func handleRefreshControl() {
        locationManager.requestLocation()

        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
}

// MARK: UITableViewDataSource 구현부
extension WeatherForecastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData?.list.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherForecastViewCell.identifier, for: indexPath) as? WeatherForecastViewCell else {
            return UITableViewCell()
        }
        guard let forecastData = forecastData else {
            return UITableViewCell()
        }
        cell.configureCell(data: forecastData.list[indexPath.row])
        return cell
    }
}

// MARK: LocationManagerDelegate 구현부
extension WeatherForecastViewController: LocationManagerDelegate {
    func didUpdateLocation() {
        guard let coordinate = locationManager.getCoordinate() else {
            return
        }
        fetchingWeatherData(coordinate: coordinate, api: WeatherAPI.current, type: CurrentWeather.self)
        fetchingWeatherData(coordinate: coordinate, api: WeatherAPI.forecast, type: ForecastWeather.self)
    }

    private func fetchingWeatherData<T: Decodable>(coordinate: CLLocationCoordinate2D, api: WeatherAPI, type: T.Type) {

        let queryItems = [CoordinatesQuery.lat: String(coordinate.latitude),
                          CoordinatesQuery.lon: String(coordinate.longitude),
                          CoordinatesQuery.appid: "e6f23abdc0e7e9080761a3cfbbdafc90"]

        guard let url = URL.createURL(API: api, queryItems: queryItems) else { return }
        networkManager.dataTask(url: url) { result in
            if case .success(let data) = result {
                do {
                    let data = try JSONDecoder().decode(type, from: data)
                    if let data = data as? CurrentWeather {
                        self.currentData = data
                        self.configureHeader(data: data)
                    } else if let data = data as? ForecastWeather {
                        self.forecastData = data
                    }
                } catch {
                    debugPrint(error)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
extension WeatherForecastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 15
    }
}
