//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class OpenWeatherMainViewController: UIViewController {
    private let locationManager = LocationManager()
    private let locationManagerDelegate = LocationManagerDelegate()
    private let tableView = UITableView()
    private let tableViewDataSource = WeatherTableviewDataSource()
    private let headerDelegate = WeatherTableViewDelegate()
    
    private let refreshControl = UIRefreshControl()

    //MARK: - View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        drawTableView()
        setRefreshControl()
        
        self.tableView.dataSource = self.tableViewDataSource
        self.tableView.delegate = headerDelegate
        
        locationManager.delegate = locationManagerDelegate
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
}

extension OpenWeatherMainViewController {
    private func setRefreshControl() {
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        self.refreshControl.addTarget(self,
                                      action: #selector(reloadView),
                                      for: .valueChanged)
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
        let iconSize = 50
        self.tableView.rowHeight = CGFloat(iconSize)
        
        let headerViewSize: CGFloat = 140
        self.tableView.sectionHeaderHeight = headerViewSize
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
