//
//  CurrentWeatherHeader.swift
//  WeatherForecast
//
//  Created by 이윤주 on 2021/10/15.
//

import UIKit

class CurrentWeatherHeader: UITableViewHeaderFooterView {
    static let headerIdentifier = "\(self)"
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private let minMaxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.backgroundColor = .white
        return stackView
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.backgroundColor = .white
        return stackView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
        configureVerticalStackView()
        configureHorizontalStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CurrentWeatherHeader {
    private func configureContents() {
        contentView.addSubview(horizontalStackView)
        contentView.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func configureVerticalStackView() {
        verticalStackView.addArrangedSubview(locationLabel)
        verticalStackView.addArrangedSubview(minMaxTemperatureLabel)
        verticalStackView.addArrangedSubview(currentTemperatureLabel)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        minMaxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureHorizontalStackView() {
        horizontalStackView.addArrangedSubview(weatherImageView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
    }
}
