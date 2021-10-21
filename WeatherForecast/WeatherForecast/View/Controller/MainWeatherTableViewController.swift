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
        
    init(weatherDataViewModel: WeatherDataViewModel) {
        self.weatherDataViewModel = weatherDataViewModel
        super.init(style: .plain)
        tableView.backgroundView = makeTableViewBackgroundView()
        tableView.separatorColor = selectTableViewSeparatorColor()
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.className)
        tableView.tableHeaderView = headerView
    }
    required init?(coder: NSCoder) {
        NSLog("init(coder:) has not been implemented")
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = makeRefreshControl(targetView: self, action: #selector(reloadWeatherData(_:)))
        tableView.tableHeaderView?.frame = makeHeaderViewFrame()
        headerView.addChangeLocationButtonTarget(target: self, action: #selector(tapChangeLocationButton))
        self.weatherDataViewModel.setDelegate(from: self)
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
    
    private func makeRefreshControl(targetView: NSObject, action: Selector) -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(targetView, action: action, for: .valueChanged)
        refreshControl.tintColor = .green
        return refreshControl
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
        let intervalWeatherData = weatherDataViewModel.intervalWeatherInfos[indexPath.row]
        let formattedDate = intervalWeatherData.date.dateFormatString()
        cell.configureTexts(date: formattedDate,
                            temperature: "\(intervalWeatherData.mainInformation.temperature.tenths)º")
        
        guard let iconName = intervalWeatherData.conditions.first?.iconName else {
            NSLog("IndexPath \(indexPath) cell - 날씨 아이콘 이름정보 없음 ")
            return cell
        }
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

// MARK: - Required Current Location
extension MainWeatherTableViewController: Requirable {
    @objc internal func reloadWeatherData(_ refreshControl: UIRefreshControl? = nil) {
        weatherDataViewModel.setUpWeatherData {
            DispatchQueue.main.async {
                if let control = refreshControl {
                    control.endRefreshing()
                }
                self.reloadHeaderView()
                self.tableView.reloadData()
                print("complete reloaded Data")
            }
        }
    }
    
    // MARK: - Alerts
    @objc private func tapChangeLocationButton() {
        presentChangeLocationAlert(title: "위치 변경", message: "변경할 좌표를 선택해주세요",
                                   options: ChangeLocation.allCases) { coordinate, option in
            switch option {
            case .change:
                guard let latitudeInput = coordinate.latitude,
                      let latitude = Double(latitudeInput),
                      let longitudeInput = coordinate.longitude,
                      let longitude = Double(longitudeInput) else {
                    self.presentWarningAlert(title: "올바른 입력이 아닙니다", message: "다시 입력해주세요", options: "확인") { _ in
                        NSLog("올바른 입력이 아님 - 에러 처리 필요.")
                    }
                    return
                }
                self.weatherDataViewModel.updateUserInputLocation(latitude, longitude)
            case .select:
                self.reloadWeatherData()
            case .cancel:
                break
            }
        }
    }
    
    func requireUserLocation() {
        presentChangeLocationAlert(title: "위치변경", message: "날씨를 받아올 위치의 위도와 경도를 입력해주세요",
                                   options: [.change, .cancel]) { coordinate, option in
            switch option {
            case .change:
                guard let latitudeInput = coordinate.latitude,
                      let latitude = Double(latitudeInput),
                      let longitudeInput = coordinate.longitude,
                      let longitude = Double(longitudeInput) else {
                    self.presentWarningAlert(title: "올바른 입력이 아닙니다", message: "다시 입력해주세요", options: "확인") { _ in
                        NSLog("올바른 입력이 아님 - 에러 처리 필요.")
                        self.reloadWeatherData()
                    }
                    return
                }
                self.weatherDataViewModel.updateUserInputLocation(latitude, longitude)
            case .cancel:
                self.reloadWeatherData()
            default:
                NSLog("허용하지 않은 Alert 메뉴")
            }
        }
    }
}

// MARK: - HeaderView
extension MainWeatherTableViewController {
    private func makeHeaderViewFrame() -> CGRect {
        return  CGRect(x: 0, y: 0, width: view.bounds.width, height: headerView.calculateHeaderHeight())
    }
    
    private func reloadHeaderView() {
        let temperatureRange = (min: weatherDataViewModel.currentMinimumTemperature,
                                max: weatherDataViewModel.currentMaximumTemperature)
        headerView.configureTexts(address: weatherDataViewModel.currentAddress,
                         temperatureRange: "최소 \(temperatureRange.min.tenths)º 최대 \(temperatureRange.max.tenths)º",
                              temperature: "\(weatherDataViewModel.currentTemperature.tenths)º")
        
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
