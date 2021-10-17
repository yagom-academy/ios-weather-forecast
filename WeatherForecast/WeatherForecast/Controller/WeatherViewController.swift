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
    
    private var tableViewRows: Int = .zero {
        didSet {
            DispatchQueue.main.async {
                self.weatherTableView.reloadData()
            }
        }
    }
    
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
    
    private func failureFetchingWeather(error: Error?) {
        let alert = UIAlertController.generateErrorAlertController(message: error?.localizedDescription)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - ViewModel Delegate
extension WeatherViewController: WeatherViewModelDelegete {
    
    func setHederViewContents(_ viewModel: WeatherHeaderModel?) {
        weatherHeaderView.configureContents(address: viewModel?.address,
                                            minTempature: viewModel?.minTempature,
                                            maxTempature: viewModel?.maxTempature,
                                            currentTempature: viewModel?.currentTempature,
                                            iconImage: viewModel?.iconImage)
    }
    
    func setTableViewRows(_ count: Int) {
        self.tableViewRows = count
    }
}

// MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        
        let cellViewModel = WeatherViewModel.getCellViewModel(at: indexPath)
        
        guard let url = URL(string: WeatherAPI.icon.url + cellViewModel.iconPath) else {
            return UITableViewCell()
        }
        cell.cellId = url.lastPathComponent
        WeatherNetworkManager().weatherIconImageDataTask(url: url) { [cell] image in
            guard cell.cellId == url.lastPathComponent else {
                return
            }
            
            DispatchQueue.main.async {
                cell.configureContents(date: cellViewModel.date,
                                       tempature: cellViewModel.tempature,
                                       weatherImage: image)
            }
        }
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
