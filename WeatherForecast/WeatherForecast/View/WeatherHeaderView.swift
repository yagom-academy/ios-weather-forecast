//
//  WeatherHeaderView.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/10/14.
//

import UIKit

class WeatherHeaderView: UICollectionReusableView {
    lazy var addressLabel = makeLabel(font: .caption1)
    lazy var maxTemperatureLabel = makeLabel(font: .callout)
    lazy var minTemperatureLabel = makeLabel(font: .callout)
    lazy var temperatureLabel = makeLabel(font: .title1)
    lazy var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        return imageView
    }()
    
    lazy var maxMinStackView: UIStackView = {
        var maxMinStackView = UIStackView(arrangedSubviews: [minTemperatureLabel, maxTemperatureLabel])
        maxMinStackView.translatesAutoresizingMaskIntoConstraints = false
        maxMinStackView.alignment = .fill
        maxMinStackView.distribution = .fill
        maxMinStackView.axis = .horizontal
        maxMinStackView.spacing = 5
        return maxMinStackView
    }()
    
    lazy var infoStackView: UIStackView = {
        var infoStackView = UIStackView(arrangedSubviews: [addressLabel, maxMinStackView, temperatureLabel])
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.alignment = .leading
        infoStackView.distribution = .fill
        infoStackView.axis = .vertical
        infoStackView.spacing = 5
        return infoStackView
    }()
    
    lazy var currentWeatherStackView: UIStackView = {
        var currentWeatherStackView = UIStackView(arrangedSubviews: [weatherIcon, infoStackView])
        currentWeatherStackView.translatesAutoresizingMaskIntoConstraints = false
        currentWeatherStackView.alignment = .center
        currentWeatherStackView.distribution = .fillProportionally
        currentWeatherStackView.axis = .horizontal
        currentWeatherStackView.spacing = 5
        addSubview(currentWeatherStackView)
        return currentWeatherStackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayoutForCurrentWeatherStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayoutForCurrentWeatherStackView() {
        NSLayoutConstraint.activate([
            currentWeatherStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                             constant: 5),
            currentWeatherStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            currentWeatherStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            currentWeatherStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func makeLabel(font: UIFont.TextStyle) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: font)
        label.text = "-"
        return label
    }
    
    func configureContents(from currentWeather: WeatherHeader?) {
        addressLabel.text = currentWeather?.address
        if let maxTemperature = currentWeather?.maxTemperature {
            maxTemperatureLabel.text = "최고 " + maxTemperature + "°"
        }
        if let minTemperature = currentWeather?.minTemperature {
            minTemperatureLabel.text = "최저 " + minTemperature + "°"
        }
        if let temperature = currentWeather?.temperature {
            temperatureLabel.text = temperature + "°"
        }
        weatherIcon.image = currentWeather?.image
    }
}
