//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation
class WeatherViewController: UIViewController {
    
    enum NameSpace {
        enum TableView {
            static let rowheight: CGFloat = 50
            static let heightHeaderView: CGFloat = 120
            static let backGroundImage = "background"
        }
    }
    
    private var locationManager = LocationManager()
    private var currentData: CurrentWeather?
    private var forecastData: ForecastWeather?
    
    private var weatherTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WeatherTableViewCell.self,
                           forCellReuseIdentifier: WeatherTableViewCell.identifier)
        tableView.rowHeight = NameSpace.TableView.rowheight
        tableView.backgroundView = UIImageView(image: UIImage(named: NameSpace.TableView.backGroundImage))
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        configureTableView()
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
    }
}

extension WeatherViewController {
    func configureTableView() {
        view.addSubview(weatherTableView)
        
        NSLayoutConstraint.activate([
            weatherTableView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        cell.configureContents(date: "2021/10/11",
                               tempature: "10°",
                               weatherImage: UIImage(systemName: "person"))
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NameSpace.TableView.heightHeaderView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return WeatherHeaderView()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? WeatherHeaderView else { return }
        
        headerView.configureContents(address: "서울특별시 용산구",
                                     minTempature: "1°",
                                     maxTempature: "10°",
                                     currentTempature: "11.0°",
                                     weatherImage: UIImage(systemName: "person"))
    }
}

extension WeatherViewController: LocationManagerDelegate {
    func didUpdateLocation(_ location: CLLocation) {
        fetchingWeatherData(api: WeatherAPI.current, type: CurrentWeather.self)
        fetchingWeatherData(api: WeatherAPI.forecast, type: ForecastWeather.self)
    }
    
    func fetchingWeatherData<T: Decodable>(api: WeatherAPI, type: T.Type) {
        guard let coordinate = locationManager.getCoordinate() else {
            return
        }
        
        let networkManager = NetworkManager()
        let queryItems = [CoordinatesQuery.lat: String(coordinate.latitude),
                          CoordinatesQuery.lon: String(coordinate.longitude),
                          CoordinatesQuery.appid: "e6f23abdc0e7e9080761a3cfbbdafc90"]
        
        guard let url = URL.createURL(API: api, queryItems: queryItems) else { return }
        networkManager.dataTask(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(type, from: data)
                    
                } catch {
                    
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
