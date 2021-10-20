//
//  WeatherTableViewHeader.swift
//  WeatherForecast
//
//  Created by WANKI KIM on 2021/10/17.
//

import UIKit

class WeatherTableHeaderView: UITableViewHeaderFooterView {
    private enum Constraint {
        static let inset: CGFloat = 10
    }
    static let reuseIdentifier = "\(WeatherTableHeaderView.self)"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .black
        return label
    }()
    
    private let minMaxTemperatureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .black
        return label
    }()
    
    private let currentTemperatureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = .black
        return label
    }()
    
    private let currentWeatherStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        if #available(iOS 14.0, *) {
            self.backgroundConfiguration = .clear()
        } else {
            self.backgroundColor = .clear
        }
        applyViewSetting()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        applyViewSetting()
    }
}

// MARK: - View Configuration
extension WeatherTableHeaderView: ViewConfiguration {
    func buildHerarchy() {
        contentView.addSubViews(containerStackView)
        containerStackView.addArrangedSubviews(iconImageView,
                                               currentWeatherStackView)
        currentWeatherStackView.addArrangedSubviews(addressLabel,
                                                    minMaxTemperatureLabel,
                                                    currentTemperatureLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constraint.inset),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constraint.inset),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            iconImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.22),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor)
        ])
    }
}

// MARK: - Configure Cell
extension WeatherTableHeaderView {
    func configure(with weather: TodayWeatherInfo) {
        weather.coordinate.flatMap {
            $0.convertToAddress { placemark in
                if let name = placemark.name,
                   let local = placemark.locality {
                    self.addressLabel.text = "\(local) \(name)"
                }
            }
        }
        weather.main.flatMap {
            $0.convertToCelsius(with: $0.minimumTemperature)
                .flatMap { min in
                    self.minMaxTemperatureLabel.text = "최소 \(min)°"
                }
            
            $0.convertToCelsius(with: $0.maximumTemperature)
                .flatMap { min in
                    self.minMaxTemperatureLabel.text! += " 최대 \(min)°"
                }
            
            $0.convertToCelsius(with: $0.temperature)
                .flatMap { temperature in
                    self.currentTemperatureLabel.text = "\(temperature)°"
                }
        }
        weather.weather?.first?
            .icon.flatMap {
                configureImage(with: $0)
        }
    }
    
    func configureImage(with iconType: String) {
        let url = URLGenerator().generateImageURL(with: iconType)
        imageLoader.loadImage(from: url) { image in
            imageCache.add(image, forKey: url)
            DispatchQueue.main.async {
                self.iconImageView.image = image
            }
        }
    }
}
