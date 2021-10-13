//
//  WeatherForecastHeaderView.swift
//  WeatherForecast
//
//  Created by 박태현 on 2021/10/13.
//

import UIKit
import CoreLocation

class WeatherForecastHeaderView: UIView {
    private let iconImageView = UIImageView()
    private let locationLabel = UILabel()
    private let minMaxTempLabel = UILabel()
    private let currentTempLabel = UILabel()
    private let stackView = UIStackView()

    private let measurementFormatter = MeasurementFormatter()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpLayout() {
        addSubview(iconImageView)
        addSubview(stackView)
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(minMaxTempLabel)
        stackView.addArrangedSubview(currentTempLabel)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        minMaxTempLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTempLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([iconImageView.topAnchor.constraint(equalTo: topAnchor),
                                     iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     iconImageView.widthAnchor.constraint(equalTo: heightAnchor),
                                     stackView.topAnchor.constraint(equalTo: topAnchor),
                                     stackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor),
                                     stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     stackView.trailingAnchor.constraint(equalTo: trailingAnchor)])
    }

    func configure(data: CurrentWeather?, placemark: CLPlacemark) {
        guard let data = data else { return }
        if let iconID = data.weather.first?.icon {
            let iconURL = "https://openweathermap.org/img/w/\(iconID).png"
            iconImageView.setImageURL(iconURL)
        }
        if let administrativeArea = placemark.administrativeArea, let thoroughfare = placemark.thoroughfare {
            let address = administrativeArea + " " + thoroughfare
            locationLabel.text = address
        }
        let minimumTemperatureText = "최저 " + measurementFormatter.convertTemp(temp: data.main.tempMin, from: .kelvin, to: .celsius)
        let maximumTemperatureText = "최고 " + measurementFormatter.convertTemp(temp: data.main.tempMax, from: .kelvin, to: .celsius)

        minMaxTempLabel.text = minimumTemperatureText + " " + maximumTemperatureText
        currentTempLabel.text = measurementFormatter.convertTemp(temp: data.main.temp, from: .kelvin, to: .celsius)
    }
}
