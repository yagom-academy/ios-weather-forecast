//
//  CurrentWeatherHeaderView.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/18.
//

import UIKit

class CurrentWeatherHeaderView: UICollectionReusableView {
    private let imageManager = ImageManager()
    static let identifier = String(describing: CurrentWeatherHeaderView.self)
    
    private let weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private let maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private let minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    private let weatherStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        return stackView
    }()
    
    private let temperatureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 5
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        temperatureStackView.addArrangedSubview(minTemperatureLabel)
        temperatureStackView.addArrangedSubview(maxTemperatureLabel)
        weatherStackView.addArrangedSubview(addressLabel)
        weatherStackView.addArrangedSubview(temperatureStackView)
        weatherStackView.addArrangedSubview(currentTemperatureLabel)
        addSubview(weatherStackView)
        addSubview(weatherImage)
        
        weatherImage.leadingAnchor.constraint(equalTo: leadingAnchor)
            .isActive = true
        weatherImage.centerYAnchor.constraint(equalTo: centerYAnchor)
            .isActive = true
        weatherImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2)
            .isActive = true
        weatherImage.heightAnchor.constraint(equalTo: weatherImage.widthAnchor)
            .isActive = true
        
        weatherStackView.topAnchor.constraint(equalTo: topAnchor)
            .isActive = true
        weatherStackView.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor,
                                                  constant: 8)
            .isActive = true
        weatherStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
            .isActive = true
        weatherStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            .isActive = true
    }
    
    func configure(weather: CurrentWeather?, address: String?) {
        addressConfigure(address: address)
        textConfigure(weather: weather)
        imageConfigure(weather: weather)
    }
    
    private func addressConfigure(address: String?) {
        addressLabel.text = address
    }
    
    private func textConfigure(weather: CurrentWeather?) {
        if let currentTemperature = weather?.main?.temp,
           let minTemperature = weather?.main?.tempMin,
           let maxTemperature = weather?.main?.tempMax {
            currentTemperatureLabel.text =
            MeasurementFormatter().convertTemperature(temp: currentTemperature)
            minTemperatureLabel.text =
            "최저" + MeasurementFormatter().convertTemperature(temp: minTemperature)
            maxTemperatureLabel.text =
            "최고" + MeasurementFormatter().convertTemperature(temp: maxTemperature)
        }
    }
    
    private func imageConfigure(weather: CurrentWeather?) {
        guard let icon = weather?.weather?.first?.icon else { return }
        imageManager.fetchImage(url: ImageURL.weather(icon).path) { image in
            DispatchQueue.main.async {
                switch image {
                case .success(let image):
                    self.weatherImage.image = image
                case .failure(let error):
                    self.weatherImage.image = UIImage(systemName: "questionmark.circle")
                    ErrorHandler(error: error).printErrorDescription()
                }
            }
        }
    }
}
