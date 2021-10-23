//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherViewController: UIViewController {
    
    enum NameSpace {
        enum TableView {
            static let rowheight: CGFloat = 50
            static let heightHeaderView: CGFloat = 120
            static let backGroundImage = "background"
        }
    }
    
    private var model: FiveDaysWeather?
    
    private let WeatherViewModel = WeatherTableViewModel()
    private let weatherHeaderView = WeatherHeaderView()
    
    private let weatherTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WeatherTableViewCell.self,
                           forCellReuseIdentifier: WeatherTableViewCell.identifier)
        tableView.rowHeight = NameSpace.TableView.rowheight
        tableView.backgroundView = UIImageView(image: UIImage(named: NameSpace.TableView.backGroundImage))
        tableView.separatorColor = .white
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureRefreshControl()
        self.weatherTableView.delegate = self
        self.weatherTableView.dataSource = self
        WeatherViewModel.delegate = self
    }
}

// MARK: - Method
extension WeatherViewController {
    private func configureTableView() {
        view.addSubview(weatherTableView)
        
        NSLayoutConstraint.activate([
            weatherTableView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateWeather), for: .valueChanged)
        refresh.tintColor = .systemRed
        weatherTableView.refreshControl = refresh
    }
    
    @objc func updateWeather() {
        WeatherViewModel.action(.refresh)
        weatherTableView.refreshControl?.endRefreshing()
    }
}

// MARK: - ViewModel Delegate
extension WeatherViewController: WeatherViewModelDelegete {
    func setViewContents(_ current: CurrentWeather?, _ fiveDays: FiveDaysWeather?) {
        DispatchQueue.main.async {
            self.weatherHeaderView.configure(current)
            self.model = fiveDays
            self.weatherTableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.list.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        
        guard let currentModel = model?.list[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(currentModel)
        
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
