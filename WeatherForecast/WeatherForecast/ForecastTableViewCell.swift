//
//  ForecastTableViewCell.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/22.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    var weatherImage: UIImageView = UIImageView()
    var timeDateLabel: UILabel = UILabel()
    var averageTemperatureLabel: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(timeDateLabel)
        self.contentView.addSubview(averageTemperatureLabel)
        self.contentView.addSubview(weatherImage)
        
        setUpLabel()
        setUpImageView()
        
        NSLayoutConstraint.activate([
            timeDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            timeDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            timeDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            timeDateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            averageTemperatureLabel.leadingAnchor.constraint(equalTo: timeDateLabel.trailingAnchor),
            averageTemperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            averageTemperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            averageTemperatureLabel.trailingAnchor.constraint(equalTo: weatherImage.leadingAnchor, constant: -10),
            averageTemperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpImageView() {
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weatherImage.widthAnchor.constraint(equalToConstant: 40),
            weatherImage.heightAnchor.constraint(equalTo: weatherImage.widthAnchor),
            weatherImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherImage.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 10),
            weatherImage.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            weatherImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
    
    private func setUpLabel() {
        timeDateLabel.translatesAutoresizingMaskIntoConstraints = false
        timeDateLabel.font = .preferredFont(forTextStyle: .body)
        timeDateLabel.textColor = .black
        timeDateLabel.adjustsFontForContentSizeCategory = true
        
        averageTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        averageTemperatureLabel.font = .preferredFont(forTextStyle: .body)
        averageTemperatureLabel.textColor = .black
        averageTemperatureLabel.adjustsFontForContentSizeCategory = true
    }
    
    override func prepareForReuse() {
        timeDateLabel.text = nil
        averageTemperatureLabel.text = nil
        weatherImage.image = nil
    }
}
