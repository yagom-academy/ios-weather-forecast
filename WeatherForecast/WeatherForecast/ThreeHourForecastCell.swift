//
//  threeHourForecastCell.swift
//  WeatherForecast
//
//  Created by 이윤주 on 2021/10/15.
//

import UIKit

class ThreeHourForecastCell: UITableViewCell {
    static let cellIdentifier = "\(self)"
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let weatherInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContents()
        configureStackView()
        backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ThreeHourForecastCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dateLabel.text = nil
        temperatureLabel.text = nil
        weatherImageView.image = nil
    }
    
    func setUp(with forecastInfo: List) {
        guard let iconName = forecastInfo.weather[0].icon else {
            return
        }
        let date = forecastInfo.date.converToDateFormat()
        let temperature = forecastInfo.main.temp.convertToCelsius().description
        let iconURL = "https://openweathermap.org/img/w/\(iconName).png"
        guard let url = URL(string: iconURL) else {
            return
        }
        
        dateLabel.text = date
        temperatureLabel.text = temperature + "°"
        weatherImageView.loadImage(from: url)
    }
    
    private func configureContents() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(weatherInfoStackView)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            weatherInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            weatherInfoStackView.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            weatherInfoStackView.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor)
        ])
    }
    
    private func configureStackView() {
        weatherInfoStackView.addArrangedSubview(temperatureLabel)
        weatherInfoStackView.addArrangedSubview(weatherImageView)
        
        weatherImageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
}
