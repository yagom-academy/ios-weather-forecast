//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    private let tableView = UITableView()
    private let tableViewHeaderView = UIView()
    private let headerAddrressLabel = UILabel()
    private let headerMinMaxTemperatureLabel = UILabel()
    private let headerCurrentTemperatureLabel = UILabel()
    private let refreshControl = UIRefreshControl()
    
    private let locationManager = LocationManager()
    private let geocoderManager = GeocoderManager()
    private let apiManager = APIManager()
    
    private var coordinate = CLLocationCoordinate2D() {
        didSet {
            fetchWeatherData(on: coordinate)
        }
    }
    
    private var fiveDaysWeatherList: [List] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        updateTableViewHeaderViewLayout()
        updateTableViewBackgroundView()
        setupRefreshControl()
        requestLocationAuthorization()
    }
    
    private func setupRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        requestCoordinate()
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fiveDaysWeatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(on: fiveDaysWeatherList[indexPath.row])
        
        return cell
    }
}

extension WeatherViewController {
    private func updateTableViewBackgroundView() {
        tableView.backgroundView = UIImageView(image: UIImage(named: "sunset"))
    }
    
    private func updateTableViewHeaderViewLayout() {
        tableViewHeaderView.addSubview(headerAddrressLabel)
        tableViewHeaderView.addSubview(headerMinMaxTemperatureLabel)
        tableViewHeaderView.addSubview(headerCurrentTemperatureLabel)
        
        tableView.tableHeaderView = tableViewHeaderView
        tableView.tableHeaderView?.frame.size.height = 150
        
        headerAddrressLabel.translatesAutoresizingMaskIntoConstraints = false
        headerAddrressLabel.leadingAnchor.constraint(
            equalTo: tableViewHeaderView.leadingAnchor,
            constant: 20
        ).isActive = true
        headerAddrressLabel.topAnchor.constraint(
            equalTo: tableViewHeaderView.topAnchor,
            constant: 20
        ).isActive = true
        headerAddrressLabel.textColor = .lightGray
        
        headerMinMaxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        headerMinMaxTemperatureLabel.leadingAnchor.constraint(
            equalTo: tableViewHeaderView.leadingAnchor,
            constant: 20
        ).isActive = true
        headerMinMaxTemperatureLabel.topAnchor.constraint(
            equalTo: headerAddrressLabel.bottomAnchor,
            constant: 10
        ).isActive = true
        headerMinMaxTemperatureLabel.textColor = .lightGray

        headerCurrentTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        headerCurrentTemperatureLabel.leadingAnchor.constraint(
            equalTo: tableViewHeaderView.leadingAnchor,
            constant: 20
        ).isActive = true
        headerCurrentTemperatureLabel.topAnchor.constraint(
            equalTo: headerMinMaxTemperatureLabel.bottomAnchor,
            constant: 10
        ).isActive = true
        headerCurrentTemperatureLabel.textColor = .white
        
        headerCurrentTemperatureLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(40))
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let layoutConstraintAttribute: [NSLayoutConstraint.Attribute] = [.leading, .trailing, .top, .bottom]
        let tableVeiwContraints = layoutConstraintAttribute.map { attr in
            return NSLayoutConstraint(item: tableView,
                                      attribute: attr,
                                      relatedBy: .equal,
                                      toItem: view,
                                      attribute: attr,
                                      multiplier: 1,
                                      constant: 0)
        }
        NSLayoutConstraint.activate(tableVeiwContraints)

        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        tableView.dataSource = self
    }
}

extension WeatherViewController {
    private func requestLocationAuthorization() {
        locationManager.requestAuthorization { [weak self] coordinate in
            self?.coordinate = coordinate
        }
    }
    
    private func requestCoordinate() {
        locationManager.requestLocation()
    }
    
    private func convertToCelsius(on fahrenheit: Double?) -> String {
        guard let fahrenheit = fahrenheit else {
            return " "
        }
        return "\(String(format: "%.2f", fahrenheit - 273.15)) ℃"
    }
    
    private func fetchWeatherData(on coordinate: CLLocationCoordinate2D) {
        fetchWeatherAPI(CurrentWeather.self,
                        weatherURL: .weatherCoordinates(latitude: coordinate.latitude,
                                                        longitude: coordinate.longitude),
                        completion: { data in
                            guard let currentMainData = data.main,
                                  let temp = currentMainData.temp,
                                  let minTemp = currentMainData.tempMin,
                                  let maxTemp = currentMainData.tempMax else {
                                return
                            }
                            DispatchQueue.main.async {
                                self.headerMinMaxTemperatureLabel.text = "최저 \(self.convertToCelsius(on: minTemp)) 최고 \(self.convertToCelsius(on: maxTemp))"
                                self.headerCurrentTemperatureLabel.text = "\(self.convertToCelsius(on: temp))"
                            }
                        })
        fetchWeatherAPI(FiveDaysWeather.self,
                        weatherURL: .forecastCoordinates(latitude: coordinate.latitude,
                                                         longitude: coordinate.longitude),
                        completion: { data in
                            guard let list = data.list else {
                                return
                            }
                            self.fiveDaysWeatherList = list
                        })
        fetchAddress(on: coordinate)
    }
    
    private func fetchWeatherAPI<T: Decodable>(
        _ type: T.Type,
        weatherURL: WeatherURL,
        completion: @escaping((T) -> Void)
    ) {
        let apiResource = APIResource(apiURL: weatherURL)
        let weatherResultAction = generateResultAction(T.self, completion: completion)
        
        apiManager.requestAPI(resource: apiResource, completion: weatherResultAction)
    }
    
    private func fetchAddress(on coordinate: CLLocationCoordinate2D) {
        geocoderManager.requestAddress(on: coordinate) { result in
            switch result {
            case .success(let address):
                guard let administrativeArea = address.administrativeArea,
                      let locality = address.locality else {
                    return
                }
                DispatchQueue.main.async {
                    self.headerAddrressLabel.text = "\(administrativeArea) \(locality)"
                }
            case .failure(let error):
                self.handlerError(error)
            }
        }
    }
    
    private func generateResultAction<T: Decodable>(
        _ type: T.Type,
        completion: @escaping (T) -> Void
    ) -> ((Result<Data, Error>) -> Void) {
        func resultAction(result: Result<Data, Error>) {
            do {
                switch result {
                case .success(let data):
                    let decoder = DecodingManager()
                    let parsedData = try decoder.decodeJSON(T.self, from: data)
                    completion(parsedData)
                case .failure(let error):
                    handlerError(error)
                }
            } catch {
                handlerError(error)
            }
        }
        
        return resultAction
    }
}
