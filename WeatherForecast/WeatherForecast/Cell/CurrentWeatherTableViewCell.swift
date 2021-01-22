//
//  CurrentWeatherTableViewCell.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/22.
//

import UIKit

class CurrentWeatherTableViewCell: UITableViewCell {
    private let weatherImageWidth: CGFloat = 60
    
    // MARK: - UI Property
    private lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.widthAnchor.constraint(equalToConstant: weatherImageWidth).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0).isActive = true
        return imageView
    }()
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.text = WeatherString.basic
        return label
    }()
    private lazy var minMaxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.text = WeatherString.basic
        return label
    }()
    private lazy var averageTemperatureLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.text = WeatherString.basic
        return label
    }()
    
    // MARK: - init func
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpWeatherImage()
        setUpTemperatureStack()
        setUpUI(with: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setting UI func
    private func setUpWeatherImage() {
        contentView.addSubview(weatherImageView)
        weatherImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        weatherImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    private func setUpTemperatureStack() {
        let containerStack = UIStackView()
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        containerStack.axis = .vertical
        containerStack.spacing = 10
        containerStack.heightAnchor.constraint(greaterThanOrEqualToConstant: weatherImageWidth).isActive = true
        contentView.addSubview(containerStack)
        containerStack.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 20).isActive = true
        containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        containerStack.addArrangedSubview(addressLabel)
        containerStack.addArrangedSubview(minMaxTemperatureLabel)
        containerStack.addArrangedSubview(averageTemperatureLabel)
    }
    
    func setUpUI(with weather: CurrentWeather?) {
        // TODO: add image
        
        
    }
}
