//
//  TableViewController.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/19.
//

import UIKit

class TableViewController: UIViewController {

    private let tableView = UITableView()
    private let tableViewDataSource = WeatherTableviewDataSource()
    private let tableViewDelegate = WeatherTableViewDelegate()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        drawTableView()
        setRefreshControl()
        
        self.tableView.dataSource = self.tableViewDataSource
        self.tableView.delegate = tableViewDelegate
        addButtonController()
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
    
    private func addButtonController() {
        if let t = tableView.tableHeaderView as? OpenWeatherHeaderView {
            self.add(t.buttonvc)
        }
    }
    
    @objc func reloadTableView() {
        DispatchQueue.main.async { [self] in
            self.tableView.reloadData()
        }
    }
}

extension TableViewController {
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
    
    @objc private func reloadView() {
        NotificationCenter.default.post(name: .requestLocationAgain, object: nil)
    }

    @objc private func stopRefesh() {
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
