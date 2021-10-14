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
        weatherDataViewModel.setUpWeatherData {
            self.tableView.reloadData()
        }
    }
}

// MARK: - TableView DataSource
extension MainWeatherTableViewController {
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataViewModel.intervalWeatherInfos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    }
}
