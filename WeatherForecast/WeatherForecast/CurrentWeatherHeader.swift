//
//  CurrentWeatherHeader.swift
//  WeatherForecast
//
//  Created by 이윤주 on 2021/10/15.
//

import UIKit
import CoreLocation

class CurrentWeatherHeader: UITableViewHeaderFooterView {
    static let headerIdentifier = "\(self)"
    
    private let weatherImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "defaultIcon")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "😢위치 정보 없음"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let minMaxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "😢최저최고기온 정보 없음"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "😢현재기온 정보 없음"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 5
        return stackView
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 15
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
    func setUp(with currentWeather: CurrentWeather, _ location: [CLPlacemark]?) {
        guard let iconName = currentWeather.weather[0].icon,
              let address = location?.first,
              let tempMin = currentWeather.main.tempMin,
              let tempMax = currentWeather.main.tempMax else {
                  return
        }
        let minimumTemperature = convertToCelsius(from: tempMin)
        let maximumTemperature = convertToCelsius(from: tempMax)
        let currentTemperature = convertToCelsius(from: currentWeather.main.temp)
        let iconURL = "https://openweathermap.org/img/w/\(iconName).png"
        guard let url = URL(string: iconURL),
              let city = address.administrativeArea,
              let district = address.locality else{
                  return
        }
        locationLabel.text = "\(city) \(district)"
        minMaxTemperatureLabel.text = "최저 \(minimumTemperature)° 최고 \(maximumTemperature)°"
        currentTemperatureLabel.text = currentTemperature.description
        weatherImageView.loadImage(from: url)
    }
    
    private func configureContents() {
        contentView.addSubview(horizontalStackView)
        contentView.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        minMaxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureVerticalStackView() {
        verticalStackView.addArrangedSubview(locationLabel)
        verticalStackView.addArrangedSubview(minMaxTemperatureLabel)
        verticalStackView.addArrangedSubview(currentTemperatureLabel)
    }
    
    private func configureHorizontalStackView() {
        horizontalStackView.addArrangedSubview(weatherImageView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            weatherImageView.widthAnchor.constraint(equalTo: horizontalStackView.widthAnchor,
                                                    multiplier: 0.25),
            weatherImageView.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor),
            weatherImageView.leadingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor,
                                                      constant: 10)
        ])
    }
    
    private func convertToCelsius(from kelvin: Double) -> Double {
        let celsius = round(kelvin - 273.15)
        return celsius
    }
}
