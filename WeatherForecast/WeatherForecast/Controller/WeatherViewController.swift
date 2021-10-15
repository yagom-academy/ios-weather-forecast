//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherViewController: UIViewController {
    
    enum NameSpace {
        enum TableView {
            static let rowheight: CGFloat = 50
            static let heightHeaderView: CGFloat = 120
            static let backGroundImage = "background"
        }
    }
    
    //private let headerViewModel = WeatherHeaderViewModel
    //private var weatherHeaderView = WeatherHeaderView()
    
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
        configureTableView()
        configureRefreshControl()
        self.weatherTableView.delegate = self
        self.weatherTableView.dataSource = self
        
        headerViewModel.onCompleted = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.weatherHeaderView.configureContents(address: self.headerViewModel.address,
                                                    minTempature: self.headerViewModel.minTempature,
                                                    maxTempature: self.headerViewModel.maxTempature,
                                                    currentTempature: self.headerViewModel.currentTempature,
                                                    iconData: self.headerViewModel.iconData)
                self.weatherTableView.reloadData()
            }
        }
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
//        headerViewModel.refreshData()
        weatherTableView.refreshControl?.endRefreshing()
    }
    
    private func failureFetchingWeather(error: Error?) {
        let alert = UIAlertController.generateErrorAlertController(message: error?.localizedDescription)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
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
        
//        let cellViewModel = headerViewModel.getCellViewModel(at: indexPath)
//
//        headerViewModel.getWeatherIconImage(at: indexPath) { [weak self] data in
//            DispatchQueue.main.async {
//                let date = self?.headerViewModel.getForecastTime(cellViewModel?.forecastTime)
//                let tempature = self?.weatherModel.getFormattingTempature(cellViewModel?.main.temp)
//
//                cell.configureContents(date: date,
//                                       tempature: tempature,
//                                       weatherImage: UIImage(data: data))
//            }
//        }
        
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
