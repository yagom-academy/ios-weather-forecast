//
//  MainWeatherHeaderView.swift
//  WeatherForecast
//
//  Created by Kim Do hyung on 2021/10/11.
//

import UIKit

final class MainWeatherHeaderView: UIView {
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    private let weatherInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        return stackView
    }()
    private let locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = UIStackView.spacingUseSystem
        
        return stackView
    }()
    private let temperatureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = UIStackView.spacingUseSystem
        
        return stackView
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    private let lowestTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return label
    }()
    private let highestTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    private let currentTamperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        
        return label
    }()
    private let locationSettingButton: UIButton = {
        let button = UIButton()
        button.setTitle("위치 변경".localized(), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    weak var changeLocationDelegate: ChangeLocationDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpUI() {
        addSubview(weatherIconImageView)
        addSubview(weatherInformationStackView)
        
        let margin = CGFloat(10)
        temperatureStackView.addArrangedSubview(lowestTemperatureLabel)
        temperatureStackView.addArrangedSubview(highestTemperatureLabel)
        
        locationStackView.addArrangedSubview(addressLabel)
        locationStackView.addArrangedSubview(locationSettingButton)
        
        weatherInformationStackView.addArrangedSubview(locationStackView)
        weatherInformationStackView.addArrangedSubview(temperatureStackView)
        weatherInformationStackView.addArrangedSubview(currentTamperatureLabel)
        
        weatherIconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: margin).isActive = true
        weatherIconImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
        weatherIconImageView.heightAnchor.constraint(equalTo: weatherIconImageView.widthAnchor).isActive = true
        weatherIconImageView.centerYAnchor.constraint(equalTo: weatherInformationStackView.centerYAnchor).isActive = true
        
        weatherInformationStackView.leadingAnchor.constraint(equalTo: weatherIconImageView.trailingAnchor, constant: margin).isActive = true
        weatherInformationStackView.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        weatherInformationStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin).isActive = true
        weatherInformationStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin).isActive = true
        
        locationSettingButton.addTarget(self, action: #selector(didTapLocationSettingButton), for: .touchUpInside)
    }
    
    func configure(addressData: String) {
        addressLabel.text = addressData
    }
    
    func configure(weatherData: WeatherForOneDay) {
        highestTemperatureLabel.text = "최고".localized() + (weatherData.mainWeatherInfomation?.maximumTemperature?.description ?? "") + weatherData.temperatureNotation
        lowestTemperatureLabel.text = "최저".localized() + (weatherData.mainWeatherInfomation?.minimumTemperature?.description ?? "") + weatherData.temperatureNotation
        currentTamperatureLabel.text = (weatherData.mainWeatherInfomation?.temperature?.description ?? "") + weatherData.temperatureNotation
    }
    
    func configure(image: UIImage) {
        weatherIconImageView.image = image
    }
    
    @objc private func didTapLocationSettingButton() {
        changeLocationDelegate?.locationChangeRequested()
    }
}
