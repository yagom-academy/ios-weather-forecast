//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class MainWeatherTableViewController: UITableViewController {
    private let weatherDataViewModel: WeatherDataViewModel
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.dateFormat = "MM/dd(EEE) HH시"
        return formatter
    }()
        
    init(weatherDataViewModel: WeatherDataViewModel) {
        self.weatherDataViewModel = weatherDataViewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImageView = UIImageView(image: UIImage(named: "BackGroundImage"))
        backgroundImageView.contentMode = .scaleAspectFill
        
        tableView.backgroundView = backgroundImageView
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.className)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        weatherDataViewModel.setUpWeatherData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - TableView DataSource
extension MainWeatherTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataViewModel.intervalWeatherInfos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.className,
                                                       for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        let intervalData = weatherDataViewModel.intervalWeatherInfos[indexPath.row]
        let date = dateFormatter.string(from: Date(timeIntervalSince1970: intervalData.date))
        
        print(#function)
        cell.configure(date,
                       temperature: "\(intervalData.mainInformation.temperature)º",
                       image: intervalData.conditions.last!.iconName)
        
        return cell
    }
}
