//
//  WeatherForecast - WeatherForecastViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherForecastViewController: UIViewController {
    private var tableView = UITableView(frame: .zero, style: .grouped)
    private var tableHeaderView: WeatherForecastHeaderView!
    private var locationManager = LocationManager()
    private var networkManager = NetworkManager()
    private var currentData: CurrentWeather?
    private var forecastData: ForecastWeather?
    private let dispatchGroup = DispatchGroup.init()

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
        tableView.tableHeaderView = tableHeaderView
        tableView.backgroundView = UIImageView(image: UIImage(named: "tokyo_tower.jpeg"))
        tableView.backgroundView?.alpha = 0.8
        tableView.rowHeight = view.frame.height / 15
        tableView.separatorColor = .white

        tableView.register(WeatherForecastViewCell.self, forCellReuseIdentifier: WeatherForecastViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.topAnchor),
                                     tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        configureRefreshControl()
    }

    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .orange
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherForecastViewCell.identifier, for: indexPath) as? WeatherForecastViewCell,
              let forecastData = forecastData else {
            return UITableViewCell()
        }
        cell.configureCell(data: forecastData.list[indexPath.row])
        return cell
    }
}

// MARK: LocationManagerDelegate 구현부
extension WeatherForecastViewController: LocationManagerDelegate {
    func didUpdateLocation() {
        fetchingWeatherData(api: WeatherAPI.current, type: CurrentWeather.self)
        fetchingWeatherData(api: WeatherAPI.forecast, type: ForecastWeather.self)
        dispatchGroup.notify(queue: DispatchQueue.global()) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    private func fetchingWeatherData<T: Decodable>(api: WeatherAPI, type: T.Type) {
        guard let coordinate = locationManager.getCoordinate() else {
            return
        }

        let queryItems = [CoordinatesQuery.lat: String(coordinate.latitude),
                          CoordinatesQuery.lon: String(coordinate.longitude),
                          CoordinatesQuery.appid: "e6f23abdc0e7e9080761a3cfbbdafc90"]

        guard let url = URL.createURL(API: api, queryItems: queryItems) else { return }
        dispatchGroup.enter()
        networkManager.dataTask(url: url) { [weak self] result in
            guard let self = self else { return }
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
            self.dispatchGroup.leave()
        }
    }

    private func configureHeader(data: CurrentWeather) {
        locationManager.getAddress { [unowned self] result in
            switch result {
            case .success(let placemark):
                tableHeaderView.configure(data: data, placemark: placemark)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}

// MARK: UITableViewDelegate
extension WeatherForecastViewController: UITableViewDelegate {}
