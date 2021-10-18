//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class OpenWeatherMainViewController: UIViewController {
    private let locationManager = LocationManager()
 
    private let tableView = UITableView()
    private let tableViewDataSource = WeatherTableviewDataSource()
    private let headerDelegate = WeatherTableViewDelegate()
    
    //MARK: - View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        drawTableView()
        setRefreshControl()

        self.tableView.dataSource = self.tableViewDataSource
        self.tableView.delegate = headerDelegate
        locationManager.delegate = self
        locationManager.askUserLocation()
        
        //MARK: Notified after OpenWeatherAPI response delivered successfully
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadTableView),
                                               name: .reloadTableView,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(stopRefesh),
                                               name: .stopRefresh,
                                               object: nil)
    }
    
    @objc func reloadTableView() {
        DispatchQueue.main.async { [self] in
            self.tableView.reloadData()
        }
    }
    
    deinit {
        print(#function)
    }
    
    private let refreshControl = UIRefreshControl()
}

extension OpenWeatherMainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let latitude = locations.last?.coordinate.latitude,
              let longitude = locations.last?.coordinate.longitude else {
            return
        }
        
        let location: Location = (latitude, longitude)
        let sessionDelegate = OpenWeatherSessionDelegate()
        let networkManager = WeatherNetworkManager()
        
        networkManager.fetchOpenWeatherData(latitudeAndLongitude: location,
                                            requestPurpose: .currentWeather,
                                            sessionDelegate.session)
        
        networkManager.fetchOpenWeatherData(latitudeAndLongitude: location,
                                            requestPurpose: .forecast,
                                            sessionDelegate.session)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        if let error = error as? CLError {
            switch error.code {
            case .locationUnknown:
                break
            default:
                print(error.localizedDescription)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            showAlert(title: "❌",
                      message: "날씨 정보를 사용 할 수 없습니다.")
            break
        case .authorizedWhenInUse, .authorizedAlways, .notDetermined:
            manager.requestLocation()
            break
        @unknown default:
            showAlert(title: "🌟",
                      message: "애플이 새로운 정보를 추가했군요! 확인 해 봅시다😄")
        }
    }
}

extension OpenWeatherMainViewController {
    private func setRefreshControl() {
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        self.refreshControl.addTarget(self, action: #selector(reloadView), for: .valueChanged)
    }
    
    @objc func reloadView() {
        self.locationManager.requestLocation()
    }
    
    @objc func stopRefesh() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()

        }
    }
    
    private func drawTableView() {
        self.view.addSubview(tableView)
        self.tableView.frame = self.view.bounds
        self.tableView.register(FiveDaysForecastCell.self,
                                forCellReuseIdentifier: "weatherCell")
        self.tableView.register(OpenWeatherHeaderView.self,
                                forHeaderFooterViewReuseIdentifier: "weatherHeaderView")
        let iconSize = 40
        self.tableView.rowHeight = CGFloat(iconSize)
        
        let headerViewSize: CGFloat = 140
        self.tableView.backgroundColor = .clear
        self.tableView.backgroundView?.addBackground(imageName: "cat")
    }
    
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인",
                                            style: .default,
                                            handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
