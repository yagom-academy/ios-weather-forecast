//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private let networkManager = NetworkManager<WeatherRequest>()
    private let parsingManager = ParsingManager()
    private var currentWeather: CurrentWeather?
    private var fiveDayForecast: FiveDayForecast?
    private var address: [CLPlacemark]? = []
    private var locationManager = CLLocationManager()
    private var weatherTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        setBackgroundImage()
        setUpTableView()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fiveDayForecast?.list?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: threeHourForecastCell.cellIdentifier, for: indexPath) as? threeHourForecastCell else {
            return UITableViewCell()
        }
        if let fiveDayForercast = fiveDayForecast {
            cell.setUp(with: fiveDayForercast, of: indexPath)
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = weatherTableView.dequeueReusableHeaderFooterView(withIdentifier: CurrentWeatherHeader.headerIdentifier) as! CurrentWeatherHeader
        guard let currentWeather = currentWeather else {
            return UIView()
        }
        view.setUp(with: currentWeather, address)
        
        return view
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latitude = locations.first?.coordinate.latitude,
              let longitude = locations.first?.coordinate.longitude else { return }
        fetchCurrentWeather(latitude: latitude, longitude: longitude)
        fetchFiveDayForecast(latitude: latitude, longitude: longitude)
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
            self.address = placemarks
        }
    }
}

extension ViewController {
    private func setUpTableView() {
        view.addSubview(weatherTableView)
        weatherTableView.backgroundColor = UIColor.clear
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        weatherTableView.register(threeHourForecastCell.self, forCellReuseIdentifier: threeHourForecastCell.cellIdentifier)
        weatherTableView.register(CurrentWeatherHeader.self,
                                  forHeaderFooterViewReuseIdentifier: CurrentWeatherHeader.headerIdentifier)
        weatherTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            weatherTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setBackgroundImage() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "weatherAppBg")
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          imageView.topAnchor.constraint(equalTo: view.topAnchor),
          imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func fetchCurrentWeather(latitude: Double, longitude: Double) {
        networkManager.request(WeatherRequest.getCurrentWeather(latitude: latitude, longitude: longitude)) { result in
            switch result {
            case .success(let data):
                let decodedData = self.parsingManager.parse(data, to: CurrentWeather.self)
                switch decodedData {
                case .success(let modelType):
                    self.currentWeather = modelType
                    DispatchQueue.main.async {
                        self.weatherTableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchFiveDayForecast(latitude: Double, longitude: Double) {
        networkManager.request(WeatherRequest.getFiveDayForecast(latitude: latitude, longitude: longitude)) { result in
            switch result {
            case .success(let data):
                let decodedData = self.parsingManager.parse(data, to: FiveDayForecast.self)
                switch decodedData {
                case .success(let modelType):
                    self.fiveDayForecast = modelType
                    DispatchQueue.main.async {
                        self.weatherTableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
