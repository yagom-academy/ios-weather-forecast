//
//  WeatherTableViewHeader.swift
//  WeatherForecast
//
//  Created by WANKI KIM on 2021/10/17.
//

import UIKit

protocol LocationSettingDelegate: NSObject {
    func showAlert()
}

class WeatherTableHeaderView: UITableViewHeaderFooterView {
    
    weak var locationSettingDelegate: LocationSettingDelegate?
    
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
    
    private let locationSettingButton: UIButton = {
        let button = UIButton()
        button.setTitle("위치설정", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.backgroundColor = .white
        return button
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
    func buildHierarchy() {
        contentView.addSubViews(containerStackView, locationSettingButton)
        containerStackView.addArrangedSubviews(iconImageView,
                                               currentWeatherStackView)
        currentWeatherStackView.addArrangedSubviews(addressLabel,
                                                    minMaxTemperatureLabel,
                                                    currentTemperatureLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                    constant: Constraint.inset),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                       constant: -Constraint.inset),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: locationSettingButton.trailingAnchor),
            
            locationSettingButton.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                       constant: Constraint.inset),
            locationSettingButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                            constant: -Constraint.inset),
            
            iconImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.22),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor)
        ])
    }
        
    func configureViews() {
        locationSettingButton.addTarget(self, action: #selector(didTapLocationSettingButton), for: .touchUpInside)
    }
    
    @objc func didTapLocationSettingButton() {
        locationSettingDelegate?.showAlert()
    }
}

// MARK: - Configure Cell
extension WeatherTableHeaderView {
    override func prepareForReuse() {
        addressLabel.text = "-"
        minMaxTemperatureLabel.text = "-"
        currentTemperatureLabel.text = "-"
        iconImageView.image = nil
    }
    
    func configure(with weather: TodayWeatherInfo) {
        weather.coordinate
            .flatMap { $0.convertToAddress { placemark in
                    if let name = placemark.name,
                       let local = placemark.locality {
                        self.addressLabel.text = "\(local) \(name)"
                    }
                }
            }
        
        weather.main
            .flatMap { $0.convertToCelsius(with: $0.minimumTemperature) }
            .flatMap { self.minMaxTemperatureLabel.text = "최소 \($0)°" }
        
        weather.main
            .flatMap { $0.convertToCelsius(with: $0.maximumTemperature) }
            .flatMap { self.minMaxTemperatureLabel.text! += " 최대 \($0)°" }
        
        weather.main
            .flatMap { $0.convertToCelsius(with: $0.temperature) }
            .flatMap { self.currentTemperatureLabel.text = "\($0)°" }
        
        weather.weather?.first?.icon
            .flatMap { configureImage(with: $0) }
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
