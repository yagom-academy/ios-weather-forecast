//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class MainViewController: UIViewController {
    private let locationManager = LocationManager()
    private let networkManager = NetworkManager()

    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            MainViewTableViewHeaderView.self,
            forHeaderFooterViewReuseIdentifier: MainViewTableViewHeaderView.identifier
        )
        tableView.register(
            MainViewTableViewCell.self,
            forCellReuseIdentifier: MainViewTableViewCell.identifier
        )

        layoutTableView()
        
        NotificationCenter.default.addObserver(
            forName: LocationManager.locationUpdated,
            object: nil,
            queue: .main,
            using: utilizeLocation
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.requestLocation()
    }
}

// MARK: - Draw subviews
extension MainViewController {
    func layoutTableView() {
        let safeArea = view.safeAreaLayoutGuide

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

// MARK: - TableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainViewTableViewCell.identifier
        ) as? MainViewTableViewCell else {
            return UITableViewCell()
        }

        return cell
    }
}

// MARK: - TableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: MainViewTableViewHeaderView.identifier
        ) as? MainViewTableViewHeaderView else {
            return UIView()
        }

        return header
    }
}

// MARK: - Networking to get user location and address
extension MainViewController {
    private func utilizeLocation(_ notification: Notification) {
        guard let location = notification.object as? CLLocation else {
                  return
              }
        let coordinate = location.coordinate
        convertToAddress(location: location)
        requestDailyWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
        requestWeeklyWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }

    private func requestDailyWeather(latitude: Double, longitude: Double) {
        networkManager.request(
            endpoint: .daily,
            parameters: ["lat": latitude, "lon": longitude]
        ) { (result: Result<TodayWeatherInfo, Error>) in
            switch result {
            case .success:
                print("daily success")
            case .failure:
                print("daily failure")
            }
        }
    }

    private func requestWeeklyWeather(latitude: Double, longitude: Double) {
        networkManager.request(
            endpoint: .weekly,
            parameters: ["lat": latitude, "lon": longitude]
        ) { (result: Result<WeeklyWeatherForecast, Error>) in
            switch result {
            case .success(let weeklyWeatherForecast):
                print("weekly success")
            case .failure:
                print("weekly failure")
            }
        }
    }

    private func convertToAddress(location: CLLocation) {
        locationManager.convertToAddress(from: location) { placemarks, error in
            print(placemarks)
        }
    }
}
