//
//  CurrentWeatherTableViewHeaderFooterView.swift
//  WeatherForecast
//
//  Created by Dasoll Park on 2021/10/19.
//

import UIKit

class CurrentWeatherTableViewHeaderFooterView: UIView {

    let weatherImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    let addressLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        return label
    }()
    let minMaxLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        return label
    }()
    let temperatureLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .left
        return label
    }()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        self.addSubview(weatherStackView)
        weatherImageView.setContentHuggingPriority(.required, for: .horizontal)
        NSLayoutConstraint.activate([
            weatherStackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            weatherStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            weatherStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
