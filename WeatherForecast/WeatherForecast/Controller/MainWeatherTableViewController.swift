//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class MainWeatherTableViewController: UITableViewController {
    private let weatherDataViewModel: WeatherDataViewModel
    private let headerView: MainTableViewHeaderView = MainTableViewHeaderView(backgroundColor: .clear)
    private let imageLoader: ImageLoader = ImageLoader(imageCacher: NSCache<NSString, UIImage>())
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.dateFormat = "MM/dd(EEE) HH시"
        return formatter
    }()
        
    init(weatherDataViewModel: WeatherDataViewModel) {
        self.weatherDataViewModel = weatherDataViewModel
        
        super.init(style: .plain)
        tableView.backgroundView = makeTableViewBackgroundView()
        tableView.separatorColor = selectTableViewSeparatorColor()
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.className)
        tableView.tableHeaderView = headerView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.initRefresh(targetView: self, action: #selector(reloadWeatherData(_:)))
        tableView.tableHeaderView?.frame = makeHeaderViewFrame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadWeatherData()
    }
}

// MARK: - TableView 설정
extension MainWeatherTableViewController {
    private func makeTableViewBackgroundView() -> UIImageView {
        let backgroundImage = UIImage(named: "BackGroundImage")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        return backgroundImageView
    }
    
    private func selectTableViewSeparatorColor() -> UIColor {
        switch self.traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            return .black
        case .dark:
            return .white
        @unknown default:
            NSLog("\(#function) - 기본 설정 값 읽어오기 에러")
            return .clear
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
        let formattedDate = dateFormatter.string(from: Date(timeIntervalSince1970: intervalData.date))
        let iconName = intervalData.conditions[0].iconName
        cell.configureTexts(date: formattedDate, temperature: "\(intervalData.mainInformation.temperature)º")
        
        if let cachedImage = imageLoader.fetchCachedData(key: iconName) {
            cell.configureIcon(image: cachedImage)
        } else {
            if let imageUrl = WeatherAPI.makeImageURL(iconName) {
                imageLoader.imageFetch(url: imageUrl) { image in
                    DispatchQueue.main.async {
                        cell.configureIcon(image: image)
                        self.imageLoader.cacheData(key: iconName, data: image)
                    }
                }
            }
        }
        return cell
    }
}

// MARK: - HeaderView
extension MainWeatherTableViewController {
    private func makeHeaderViewFrame() -> CGRect {
        return  CGRect(x: 0, y: 0, width: view.bounds.width, height: headerView.calculateHeaderHeight())
    }
    
    @objc private func reloadWeatherData(_ refreshControl: UIRefreshControl? = nil) {
        weatherDataViewModel.setUpWeatherData {
            DispatchQueue.main.async {
                if let control = refreshControl {
                    control.endRefreshing()
                }
                self.reloadHeaderView()
                self.tableView.reloadData()
            }
        }
    }
    
    private func reloadHeaderView() {
        let range = (min: weatherDataViewModel.currentMinimumTemperature,
                     max: weatherDataViewModel.currentMaximumTemperature)
        headerView.configureTexts(address: weatherDataViewModel.currentAddress,
                                  temperatureRange: "최소 \(range.min)º 최대 \(range.max)º",
                                  temperature: "\(weatherDataViewModel.currentTemperature)º")
        
        let iconName = weatherDataViewModel.currentWeatherIconName
        if let cachedImage = imageLoader.fetchCachedData(key: iconName) {
            headerView.configureIcon(image: cachedImage)
        } else {
            if let imageUrl = WeatherAPI.makeImageURL(iconName) {
                imageLoader.imageFetch(url: imageUrl) { image in
                    DispatchQueue.main.async {
                        self.headerView.configureIcon(image: image)
                        self.imageLoader.cacheData(key: iconName, data: image)
                    }
                }
            }
        }
    }
}
