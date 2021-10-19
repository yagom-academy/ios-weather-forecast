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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentWeatherViewModel.reload()
        initBackgroundView()
        setUpTableView()
        
    }
    
    func initBackgroundView() {
        let width = view.bounds.size.width
        let height = view.bounds.size.height
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageView.image = UIImage(named: "seoul.jpeg")
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        
        view.addSubview(imageView)
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
        return cell
    }
}
