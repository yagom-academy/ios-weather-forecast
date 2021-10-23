//
//  WeatherTableViewCell.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/19.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    static let identifier = "WeatherCell"
    
    private let dateLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let weatherIconImageView = UIImageView()
    
    private let apiManager = APIManager()
    private var urlString: String = ""
    private var dataTask: URLSessionDataTask?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        updateCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dataTask?.cancel()
        weatherIconImageView.image = nil
    }
}

// MARK: - Configure Cell Data
extension WeatherTableViewCell {
    func configure(on fiveDaysWeatherItem: List) {
        dateLabel.text = WeatherUtilManager.parseDateInfo(on: fiveDaysWeatherItem.dtTxt)
        temperatureLabel.text = WeatherUtilManager.convertToCelsius(on: fiveDaysWeatherItem.main?.temp)
        updateWeatherIcon(to: fiveDaysWeatherItem.weather?[0].icon)
    }
    
    private func updateWeatherIcon(to iconID: String?) {
        guard let iconID = iconID else {
            return
        }
        
        let apiURL = WeatherURL.weatherIcon(iconID: iconID)
        let apiResource = APIResource(apiURL: apiURL)
        
        let weatherURI = apiURL.weatherURI
        self.urlString = weatherURI
        if let image = ImageCacheManager.shared.loadCachedData(for: weatherURI) {
            weatherIconImageView.image = image
        } else {
            self.dataTask = apiManager.downloadImage(resource: apiResource) { [weak self] image in
                if self?.urlString == weatherURI {
                    self?.weatherIconImageView.image = image
                }
            }
        }
    }
}

// MARK: - Update Cell Layout
extension WeatherTableViewCell {
    private func updateCellLayout() {
        updateDateLabelLayout()
        updateWeatherIconImageViewLayout()
        updateTemperatureLabelLayout()
        backgroundColor = UIColor.clear
    }
    
    private func prepareForLayout(with view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
    }
    
    private func updateDateLabelLayout() {
        prepareForLayout(with: dateLabel)
        
        dateLabel.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: 10
        ).isActive = true
        
        dateLabel.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: 10
        ).isActive = true
        
        dateLabel.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -10
        ).isActive = true
        
        dateLabel.textColor = .lightGray
    }
    
    private func updateWeatherIconImageViewLayout() {
        prepareForLayout(with: weatherIconImageView)
     
        weatherIconImageView.widthAnchor.constraint(
            equalToConstant: 30
        ).isActive = true
        
        weatherIconImageView.heightAnchor.constraint(
            equalToConstant: 30
        ).isActive = true
        
        weatherIconImageView.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: -10
        ).isActive = true
        
        weatherIconImageView.centerYAnchor.constraint(
            equalTo: contentView.centerYAnchor
        ).isActive = true
    }
    
    private func updateTemperatureLabelLayout() {
        prepareForLayout(with: temperatureLabel)
        
        temperatureLabel.trailingAnchor.constraint(
            equalTo: weatherIconImageView.leadingAnchor,
            constant: -10
        ).isActive = true
        
        temperatureLabel.centerYAnchor.constraint(
            equalTo: contentView.centerYAnchor
        ).isActive = true
        
        temperatureLabel.textColor = .lightGray
    }
}
