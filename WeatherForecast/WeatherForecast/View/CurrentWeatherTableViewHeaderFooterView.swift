//
//  CurrentWeatherTableViewHeaderFooterView.swift
//  WeatherForecast
//
//  Created by Dasoll Park on 2021/10/19.
//

import UIKit

class CurrentWeatherTableViewHeaderFooterView: UITableViewHeaderFooterView {

    let weatherImageView = UIImageView()
    let addressLabel = UILabel()
    let minMaxLabel = UILabel()
    let temperatureLabel = UILabel()
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addressLabel, minMaxLabel, temperatureLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    lazy var weatherStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weatherImageView, labelStackView])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUpAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpAutoLayout()
    }
    
    func configureLabels(
        image: UIImage,
        address: String,
        minMaxTemperature: String,
        temperature: String
    ) {
        weatherImageView.image = image
        addressLabel.text = address
        minMaxLabel.text = minMaxTemperature
        temperatureLabel.text = temperature
    }
    
    private func setUpAutoLayout() {
        weatherStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(weatherStackView)
        weatherImageView.setContentHuggingPriority(.required, for: .horizontal)
        NSLayoutConstraint.activate([
            weatherStackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            weatherStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            weatherStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
