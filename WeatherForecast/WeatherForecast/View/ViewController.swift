//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    private let locationManager = LocationManager()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureLayout()
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.delegate = locationManager
        tableView.register(WeatherInfoCell.self, forCellReuseIdentifier: WeatherInfoCell.cellIdentifier)
        locationManager.askUserLocation()
        setUpTableViewData()
    }
    
    func setUpTableViewData() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            self.tableView.reloadData()
            print("갱신")
            if self.locationManager.data != nil {
                timer.invalidate()
            }
        }
    }
    
    static func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Test", style: .default, handler: nil)
            alert.addAction(alertAction)
            ViewController().present(alert, animated: true, completion: nil)
        }
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherInfoCell.cellIdentifier, for: indexPath) as? WeatherInfoCell,
              let item = locationManager.data else {
                  return UITableViewCell()
              }
        cell.dateLabel.text = "\(item.list[indexPath.row].date)"
        cell.temperatureLabel.text = "\(item.list[indexPath.row].main.temperature)"
        //        cell.weatherImageLabel.
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationManager.data?.list.count ?? 0
    }
}
