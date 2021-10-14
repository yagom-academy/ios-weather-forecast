//
//  WeatherHeaderView.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/10/14.
//

import UIKit

class WeatherHeaderView: UICollectionReusableView {
    lazy var addressLabel = makeLabel(font: .title3)
    lazy var maxTemperatureLabel = makeLabel(font: .title3)
    lazy var minTemperatureLabel = makeLabel(font: .title3)
    lazy var temperatureLabel = makeLabel(font: .title2)
    lazy var weatherIcon = UIImageView()
    
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
            currentWeatherStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 5),
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
        
        return label
    }
    
    func configureContents(from currentWeather: WeatherHeader?) {
        addressLabel.text = currentWeather?.address
        maxTemperatureLabel.text = currentWeather?.maxTemperature
        minTemperatureLabel.text = currentWeather?.minTemperature
        temperatureLabel.text = currentWeather?.temperature
        weatherIcon.image = currentWeather?.image
    }
}
