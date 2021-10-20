//
//  FiveDaysWeatherCell.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/18.
//

import UIKit

enum ImageURL {
    case weather(String)
    
    var path: String {
        switch self {
        case .weather(let id):
            return "https://openweathermap.org/img/w/\(id).png"
        }
    }
}

class FiveDaysWeatherCell: UICollectionViewCell {
    let imageManager = ImageManager()
    static let identifier = String(describing: FiveDaysWeatherCell.self)
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    private let weatherStackView: UIStackView = {
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
        setUpConstraint()
        setUpStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        weatherStackView.addArrangedSubview(dateLabel)
        weatherStackView.addArrangedSubview(temperatureLabel)
        weatherStackView.addArrangedSubview(weatherImage)
        
        self.contentView.addSubview(weatherStackView)
        
    }
    
    private func setUpStyle() {
        self.layer.addBorder(edge: .bottom, color: .white, thickness: 1)
    }
    
    private func setUpConstraint() {
        weatherStackView.topAnchor.constraint(
            equalTo: contentView.topAnchor).isActive = true
        weatherStackView.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor)
            .isActive = true
        weatherStackView.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor)
            .isActive = true
        weatherStackView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor)
            .isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        weatherImage.image = nil
        dateLabel.text = nil
        temperatureLabel.text = nil
    }
    
    func configure(list: List?) {
            textConfigure(list: list)
            imageConfigure(list: list)
        }
        
        private func textConfigure(list: List?) {
            if let date = list?.dt,
               let temperature = list?.main?.temp {
                dateLabel.text =
                DateFormatter().convertDate(intDate: date)
                temperatureLabel.text =
                MeasurementFormatter().convertTemperature(temp: temperature)
            }
        }
        
        private func imageConfigure(list: List?) {
            guard let icon = list?.weather?.first?.icon else { return }
            imageManager.fetchImage(url: ImageURL.weather(icon).path) { result in
                DispatchQueue.main.async {
                    switch result {
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
