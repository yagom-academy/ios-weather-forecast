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

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        setTableView()
        // Do any additional setup after loading the view.
    }

    func setTableView() {
        view.addSubview(tableView)
        tableHeaderView = WeatherForecastHeaderView(frame:
                            CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height * 0.15))
        tableView.tableHeaderView = tableHeaderView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WeatherForecastViewCell.self, forCellReuseIdentifier: WeatherForecastViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                                     tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)])
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
        fetchingWeatherData(api: WeatherAPI.current, type: CurrentWeather.self)
        fetchingWeatherData(api: WeatherAPI.forecast, type: ForecastWeather.self)
    }

    private func fetchingWeatherData<T: Decodable>(api: WeatherAPI, type: T.Type) {
        guard let coordinate = locationManager.getCoordinate() else {
            return
        }

        let queryItems = [CoordinatesQuery.lat: String(coordinate.latitude),
                          CoordinatesQuery.lon: String(coordinate.longitude),
                          CoordinatesQuery.appid: "e6f23abdc0e7e9080761a3cfbbdafc90"]

        guard let url = URL.createURL(API: api, queryItems: queryItems) else { return }
        networkManager.dataTask(url: url) { [unowned self] result in
            if case .success(let data) = result {
                do {
                    let data = try JSONDecoder().decode(type, from: data)
                    debugPrint(data)
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
        locationManager.getAddress { [unowned self] result in
            switch result {
            case .success(let placemark):
                tableHeaderView.configure(data: data, placemark: placemark)
            default:
                print("error")
            }
            tableView.layoutIfNeeded()
        }
    }
}

// MARK: UITableViewDelegate
extension WeatherForecastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 15
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
