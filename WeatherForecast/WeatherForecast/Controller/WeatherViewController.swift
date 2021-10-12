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
    private var weatherModel: WeatherModel?
    private var weatherHeaderView = WeatherHeaderView()
    
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
        self.weatherTableView.dataSource = self
        self.weatherTableView.delegate = self
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
        return weatherModel?.forecastData?.list.count ?? 10
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
        return weatherHeaderView
    }
}

extension WeatherViewController: LocationManagerDelegate {
    func didUpdateLocation(_ location: CLLocation) {
        fetchingWeatherData(api: WeatherAPI.current, type: CurrentWeather.self) { currentWeather, error in
            
            guard let currentWeather = currentWeather,
                  let icon = currentWeather.weather.first?.icon,
                  let iconURL = URL(string: WeatherAPI.icon.url + icon),
                  error == nil else {
                self.failureFetchingWeather(error: error)
                return
            }
            
            self.weatherModel?.currentData = currentWeather
            
            NetworkManager().dataTask(url: iconURL) { result in
                switch result {
                case .success(let data):
                    self.weatherModel?.currentData?.imageData = data
                case .failure(let error):
                    self.failureFetchingWeather(error: error)
                }
            }
            
            self.locationManager.getAddress { result in
                switch result {
                case .success(let placemark):
                    self.weatherModel?.currentPlacemark = placemark
                    self.weatherHeaderView.configureContents(address: "김재윤",
                                                             minTempature: "1111",
                                                             maxTempature: "11",
                                                             currentTempature:
                                                                "11111",
                                                             iconData: nil)
                case .failure(let error):
                    self.failureFetchingWeather(error: error)
                }
            }
        }
        
        fetchingWeatherData(api: WeatherAPI.forecast, type: ForecastWeather.self) { forecastWeather, error in
            
            guard let currentWeather = forecastWeather,
                  error == nil else {
                let alert = UIAlertController.generateErrorAlertController(message: error?.localizedDescription)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
        }
    }
    
    private func fetchingWeatherData<T: Decodable>(api: WeatherAPI,
                                                   type: T.Type,
                                                   completion: @escaping (T?, Error?) -> Void) {
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
                    completion(decodedData, nil)
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    private func failureFetchingWeather(error: Error?) {
        let alert = UIAlertController.generateErrorAlertController(message: error?.localizedDescription)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
