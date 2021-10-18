//
//  CurrentWeatherHeaderView.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/18.
//

import UIKit

class WeatherHeaderView: UICollectionReusableView {
    static let identifier = String(describing: WeatherHeaderView.self)
    
    private let weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let maxTemperatureLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let minTemperatureLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let weatherStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        return stackView
    }()
    
    private let temperatureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .leading
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        temperatureStackView.addArrangedSubview(maxTemperatureLabel)
        temperatureStackView.addArrangedSubview(minTemperatureLabel)
        weatherStackView.addArrangedSubview(addressLabel)
        weatherStackView.addArrangedSubview(temperatureStackView)
        weatherStackView.addArrangedSubview(currentTemperatureLabel)
        addSubview(weatherStackView)
        addSubview(weatherImage)
        
        weatherImage.topAnchor.constraint(equalTo: topAnchor)
            .isActive = true
        weatherImage.leadingAnchor.constraint(equalTo: leadingAnchor)
            .isActive = true
        weatherImage.bottomAnchor.constraint(equalTo: bottomAnchor)
            .isActive = true
        weatherImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2)
            .isActive = true
        weatherImage.heightAnchor.constraint(equalTo: weatherImage.widthAnchor)
            .isActive = true
        
        weatherStackView.topAnchor.constraint(equalTo: topAnchor)
            .isActive = true
        weatherStackView.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor)
            .isActive = true
        weatherStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
            .isActive = true
        weatherStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            .isActive = true
    }
    
    func configure() {
        
    }
}

