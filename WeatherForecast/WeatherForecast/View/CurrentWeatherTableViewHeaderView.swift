//
//  CurrentWeatherTableViewHeaderView.swift
//  WeatherForecast
//
//  Created by Dasoll Park on 2021/10/19.
//

import UIKit

class CurrentWeatherTableViewHeaderView: UIView {

    private let weatherImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    private let addressLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        return label
    }()
    private let minMaxLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        return label
    }()
    private let temperatureLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addressLabel, minMaxLabel, temperatureLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    private lazy var weatherStackView: UIStackView = {
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
        image: UIImage?,
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
            weatherImageView.widthAnchor.constraint(equalToConstant: 60),
            weatherStackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            weatherStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            weatherStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
