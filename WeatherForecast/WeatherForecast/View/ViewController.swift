//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    //MARK: - Properties
    private let locationManager = LocationManager()
    private let tableView = UITableView()
    private let tableViewHeaderView = UIView()
    private let currentWeatherImageView = UIImageView()
    private let addressLabel = UILabel()
    private let temperatureRangeLabel = UILabel()
    private let currentTemperatureLabel = UILabel()

    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = tableViewHeaderView
        addSubviews()
        configureLayout()
        locationManager.delegate = locationManager
        tableView.register(WeatherInfoCell.self, forCellReuseIdentifier: WeatherInfoCell.cellIdentifier)
        locationManager.askUserLocation()
        setUpTableViewData()
        self.view.addBackground(imageName: "sky")
        self.tableView.backgroundColor = .clear
    }
    
    //MARK: - Methods
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
        tableViewHeaderView.addSubview(currentWeatherImageView)
        tableViewHeaderView.addSubview(addressLabel)
        tableViewHeaderView.addSubview(temperatureRangeLabel)
        tableViewHeaderView.addSubview(currentTemperatureLabel)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableViewHeaderView.translatesAutoresizingMaskIntoConstraints = false
        currentWeatherImageView.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableViewHeaderView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            currentWeatherImageView.leadingAnchor.constraint(equalTo: tableViewHeaderView.leadingAnchor, constant: 10),
            currentWeatherImageView.topAnchor.constraint(equalTo: tableViewHeaderView.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            addressLabel.leadingAnchor.constraint(equalTo: currentWeatherImageView.trailingAnchor, constant: 10),
            addressLabel.topAnchor.constraint(equalTo: tableViewHeaderView.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            temperatureRangeLabel.leadingAnchor.constraint(equalTo: currentWeatherImageView.trailingAnchor, constant: 10),
            temperatureRangeLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            currentTemperatureLabel.leadingAnchor.constraint(equalTo: currentWeatherImageView.trailingAnchor, constant: 10),
            currentTemperatureLabel.topAnchor.constraint(equalTo: temperatureRangeLabel.bottomAnchor, constant: 10)
        ])
    }
}

//MARK: - TableView Protocol
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherInfoCell.cellIdentifier, for: indexPath) as? WeatherInfoCell,
              let item = locationManager.data else {
                  return UITableViewCell()
              }
        let networkManager = NetworkManager()
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.dateLabel.text = "\(item.list[indexPath.row].date)"
        cell.temperatureLabel.text = "\(item.list[indexPath.row].main.temperature)"
//        let id = item.list[indexPath.row].weather.icon
//        cell.weatherImageView.image = networkManager.getWeatherImage(weatherApi: FiveDaysForecast, T##session: URLSession##URLSession, T##completion: (Data) -> ()##(Data) -> ())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationManager.data?.list.count ?? 0
    }
}

extension UIView {
    func addBackground(imageName:String) {
          
        let imageViewBackground = UIImageView(frame: UIScreen.main.bounds)
           imageViewBackground.image = UIImage(named: imageName)
          
           
        imageViewBackground.contentMode = .scaleToFill
          
           self.addSubview(imageViewBackground)
           self.sendSubviewToBack(imageViewBackground)
    }
}
