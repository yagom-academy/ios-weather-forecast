//
//  CurrentWeatherTableViewCell.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/22.
//

import UIKit

class CurrentWeatherTableViewCell: UITableViewCell {
    var weatherImage: UIImageView = UIImageView()
    var verticalStackView: UIStackView = UIStackView()
    var cityNameLabel: UILabel = UILabel()
    var minAndMaxTemperatureLabel: UILabel = UILabel()
    var averageTemperatureLabel: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(weatherImage)
        self.contentView.addSubview(verticalStackView)
        
        setUpLabel()
        setUpImageView()
        setUpStackView()

        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor, constant: 10),
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            verticalStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        weatherImage.image = nil
        cityNameLabel.text = nil
        minAndMaxTemperatureLabel.text = nil
        averageTemperatureLabel.text = nil
    }
    
    private func setUpImageView() {
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weatherImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            weatherImage.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 10),
            weatherImage.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            weatherImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherImage.widthAnchor.constraint(equalToConstant: 120),
            weatherImage.heightAnchor.constraint(equalTo: weatherImage.widthAnchor)
        ])
    }
    
    private func setUpStackView() {
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fillProportionally
        verticalStackView.spacing = 10
        
        verticalStackView.addArrangedSubview(cityNameLabel)
        verticalStackView.addArrangedSubview(minAndMaxTemperatureLabel)
        verticalStackView.addArrangedSubview(averageTemperatureLabel)
    }
    
    private func setUpLabel() {
        cityNameLabel.font = .preferredFont(forTextStyle: .body)
        cityNameLabel.textColor = .black
        cityNameLabel.adjustsFontForContentSizeCategory = true
        
        minAndMaxTemperatureLabel.font = .preferredFont(forTextStyle: .body)
        minAndMaxTemperatureLabel.textColor = .black
        minAndMaxTemperatureLabel.adjustsFontForContentSizeCategory = true
        
        averageTemperatureLabel.font = .preferredFont(forTextStyle: .largeTitle)
        averageTemperatureLabel.textColor = .black
        averageTemperatureLabel.adjustsFontForContentSizeCategory = true
    }
}
