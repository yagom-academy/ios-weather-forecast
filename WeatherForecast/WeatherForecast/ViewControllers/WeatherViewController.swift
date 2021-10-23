//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    private let tableView = UITableView()
    private let tableViewHeaderView = TableViewHeaderView()
    private let refreshControl = UIRefreshControl()
    
    private let locationManager = LocationManager()
    private let geocoderManager = GeocoderManager()
    private let apiManager = APIManager()
    
    private var weatherDataSource = WeatherDataSource()
    private var coordinate = CLLocationCoordinate2D() {
        didSet {
            fetchWeatherData(on: coordinate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewDataSource()
        updateTableViewLayout()
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

extension WeatherViewController {
    private func setupTableViewDataSource() {
        weatherDataSource.dataDidUpdated = { [weak self] in
            guard let this = self else {
                return
            }
            this.tableView.reloadData()
            this.refreshControl.endRefreshing()
        }
        tableView.dataSource = weatherDataSource
    }
    
    private func updateTableViewBackgroundView() {
        tableView.backgroundView = UIImageView(image: UIImage(named: "sunset"))
    }
    
    private func updateTableViewHeaderViewLayout() {
        tableView.tableHeaderView = tableViewHeaderView
        tableView.tableHeaderView?.frame.size.height = 150
    }
    
    private func updateTableViewLayout() {
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
    }
}

extension WeatherViewController: GeocoderManagible {
    func updateCoordiante(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

extension WeatherViewController {
    private func requestLocationAuthorization() {
        geocoderManager.delegate = self
        locationManager.requestAuthorization(feat: geocoderManager)
    }
    
    private func requestCoordinate() {
        locationManager.requestLocation()
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
                                self.tableViewHeaderView.updateMinMaxTemperatureLabel(to: "최저 \(WeatherUtilManager.convertToCelsius(on: minTemp)) 최고 \(WeatherUtilManager.convertToCelsius(on: maxTemp))")
                                self.tableViewHeaderView.updateCurrentTemperatureLabel(to: "\(WeatherUtilManager.convertToCelsius(on: temp))")
                            }
                        })
        fetchWeatherAPI(FiveDaysWeather.self,
                        weatherURL: .forecastCoordinates(latitude: coordinate.latitude,
                                                         longitude: coordinate.longitude),
                        completion: { data in
                            guard let list = data.list else {
                                return
                            }
                            self.weatherDataSource.updateDataSource(on: list)
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
                    self.tableViewHeaderView.updateAddrressLabel(to: "\(administrativeArea) \(locality)")
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
