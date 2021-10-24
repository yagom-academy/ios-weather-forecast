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
    static let headerHeight = CGFloat(100)
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultIcon")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "😢위치 정보 없음"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let minMaxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "😢최저최고기온 정보 없음"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "😢현재기온 정보 없음"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
        let minimumTemperature = tempMin.convertToCelsius()
        let maximumTemperature = tempMax.convertToCelsius()
        let currentTemperature = currentWeather.main.temp.convertToCelsius()
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
        contentView.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func configureVerticalStackView() {
        labelInfoStackView.addArrangedSubview(locationLabel)
        labelInfoStackView.addArrangedSubview(minMaxTemperatureLabel)
        labelInfoStackView.addArrangedSubview(currentTemperatureLabel)
    }
    
    private func configureHorizontalStackView() {
        containerStackView.addArrangedSubview(weatherImageView)
        containerStackView.addArrangedSubview(labelInfoStackView)
        
        NSLayoutConstraint.activate([
            weatherImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            weatherImageView.widthAnchor.constraint(equalTo: weatherImageView.heightAnchor)
        ])
    }
}
