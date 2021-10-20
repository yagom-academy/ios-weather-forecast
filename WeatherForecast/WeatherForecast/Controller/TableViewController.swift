//
//  TableViewController.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/19.
//

import UIKit.UITableViewController

final class TableViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let tableViewDataSource = WeatherTableviewDataSource()
    private let tableViewDelegate = WeatherTableViewDelegate()
    private let emptyDataSource = EmptyDataSource()
    private let emptyDelegate = EmptyDelegate()
    
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        drawTableView()
        setRefreshControl()
        self.tableView.dataSource = self.tableViewDataSource
        self.tableView.delegate = tableViewDelegate
        
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(reloadTableView),
                         name: .reloadTableView,
                         object: nil)
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(stopRefesh),
                         name: .stopRefresh,
                         object: nil)
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(cleanTableView),
                         name: .cleanTalbeView,
                         object: nil)
    }

    @objc private func cleanTableView() {
        self.tableView.dataSource = emptyDataSource
        self.tableView.delegate = emptyDelegate
        self.tableView.reloadData()
    }
}

extension TableViewController {
    private func drawTableView() {
        self.view.addSubview(tableView)
        self.tableView.frame = self.view.bounds
        self.tableView.register(FiveDaysForecastCell.self,
                                forCellReuseIdentifier: "weatherCell")
        self.tableView.register(OpenWeatherHeaderView.self,
                                forHeaderFooterViewReuseIdentifier: "weatherHeaderView")
        let iconSize: CGFloat = 50
        self.tableView.rowHeight = CGFloat(iconSize)
        
        let headerViewSize: CGFloat = 120
        self.tableView.sectionHeaderHeight = headerViewSize
    }
    
    private func setRefreshControl() {
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        self.refreshControl.addTarget(self,
                                      action: #selector(requestLocationAgain),
                                      for: .valueChanged)
    }
}

extension TableViewController {
    @objc private func stopRefesh() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func requestLocationAgain() {
        NotificationCenter
            .default
            .post(name: .requestLocationAgain,
                  object: nil)
    }
    
    @objc private func reloadTableView() {
        DispatchQueue.main.async { [self] in
            self.tableView.dataSource = self.tableViewDataSource
            self.tableView.delegate = self.tableViewDelegate
            self.tableView.reloadData()
        }
    }
}
