//
//  MainWeatherTableViewCell.swift
//  WeatherForecast
//
//  Created by JINHONG AN on 2021/10/11.
//

import UIKit

final class MainWeatherTableViewCell: UITableViewCell {
    static let identifier = "MainWeatherTableViewCell"
    var iconId: String?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        
        return stackView
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    
        return label
    }()
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpUI() {
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(weatherIconImageView)
        contentView.addSubview(stackView)
        
        let margin = CGFloat(8)
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: margin).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -margin).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin).isActive = true
        
        weatherIconImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1).isActive = true
        weatherIconImageView.heightAnchor.constraint(equalTo: weatherIconImageView.widthAnchor).isActive = true
    }
    
    func configure(data: WeatherForOneDay) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let forecastedDate = data.timeOfDataForecasted, let date = dateFormatter.date(from: forecastedDate) {
            dateFormatter.locale = .current
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdEHH")
            dateLabel.text = dateFormatter.string(from: date)
        }
        
        if let kelvinTemperature = data.mainWeatherInfomation?.temperature {
            let absoluteZero = -273.15
            temperatureLabel.text = (((kelvinTemperature + absoluteZero) * 10).rounded(.toNearestOrAwayFromZero) / 10).description
        }
        
    }
    
    func configure(image: UIImage) {
        if weatherIconImageView.image == nil {
            weatherIconImageView.image = image
        }
    }
    
    func resetAllContents() {
        weatherIconImageView.image = nil
        dateLabel.text = nil
        temperatureLabel.text = nil
    }
}
