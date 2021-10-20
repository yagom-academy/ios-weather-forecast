//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainWeatherViewController: UIViewController {
    
    var currentWeatherViewModel = CurrentWeatherViewModel()
    var fiveDayListViewModel = FiveDayWeatherListViewModel()
    var weatherTableView = UITableView()
    let headerView = CurrentWeatherTableViewHeaderFooterView()
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(updateViewModels), for: .valueChanged)
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBackgroundView()
        updateViewModels()
        setUpTableView()
        initTableHeaderView()
    }
    
    private func initBackgroundView() {
        let width = view.bounds.size.width
        let height = view.bounds.size.height
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageView.image = UIImage(named: "seoul.jpeg")
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        
        view.addSubview(imageView)
    }
    
    @objc private func updateViewModels() {
        let refreshGroup = DispatchGroup()
        
        currentWeatherViewModel.mapCurrentData()
        currentWeatherViewModel.reloadTableView = {
            DispatchQueue.main.async {
                self.updateTableHeaderView()
                DispatchQueue.global().async(group: refreshGroup) {
                    self.reloadTableView()
                }
            }
        }
        fiveDayListViewModel.mapFiveDayData()
        fiveDayListViewModel.reloadTableView = {
            DispatchQueue.global().async(group: refreshGroup) {
                self.reloadTableView()
            }
        }
        refreshGroup.notify(queue: .main) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    private func setUpTableView() {
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        view.addSubview(weatherTableView)
        weatherTableView.register(WeatherTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        weatherTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherTableView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            weatherTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            weatherTableView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        weatherTableView.backgroundColor = nil
        weatherTableView.refreshControl = refreshControl
    }
    
    private func initTableHeaderView() {
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 100)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        weatherTableView.tableHeaderView = headerView
        headerView.layoutIfNeeded()
    }
    
    private func updateTableHeaderView() {
        headerView.configureLabels(
            image: currentWeatherViewModel.weatherImage,
            address: currentWeatherViewModel.address,
            minMaxTemperature: currentWeatherViewModel.minMaxTamperature,
            temperature: currentWeatherViewModel.currentTemperature
        )
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.weatherTableView.reloadData()
        }
    }
}

extension MainWeatherViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fiveDayListViewModel.numberOfRowInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: "cell") as? WeatherTableViewCell else {
            return WeatherTableViewCell()
        }
        let viewModel = fiveDayListViewModel.getData(at: indexPath.row)
        
        cell.dateLabel.text = viewModel.dateThreeHour
        cell.temperatureLabel.text = viewModel.temperatureThreeHour
        cell.weatherImageView.image = viewModel.imageThreeHour
        cell.backgroundColor = UIColor.clear
        return cell
    }
}
