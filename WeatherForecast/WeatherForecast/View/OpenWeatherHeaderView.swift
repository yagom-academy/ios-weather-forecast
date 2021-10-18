//
//  OpenWeatherHeaderView.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/15.
//

import UIKit
import CoreLocation.CLLocationManager

extension CLGeocoder {
    func makeAddress() -> String {
        guard let coordination = WeatherDataHolder.shared.current?.coordination else {
            return "야곰시 야곰동"
        }
        let currentLocation = CLLocation(latitude: coordination.lattitude, longitude: coordination.longitude)
        
        let locale = Locale(identifier: "ko")
        var address = ""
        self.reverseGeocodeLocation(currentLocation, preferredLocale: locale) { placeMarks, error in
            guard error == nil else {
                return
            }
            
            guard let addresses = placeMarks,
                  let currentAddress = addresses.last?.name else {
                return
            }
            address = currentAddress
        }
        return address
    }
}

class OpenWeatherHeaderView: UITableViewHeaderFooterView {
    static let identifier = "weatherHeaderView"
    
    private let addressLabel = UILabel()
    private let minMaxTemperature = UILabel()
    private let currentTemperatureLabel = UILabel()
    private let iconImageView = UIImageView()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.addressLabel, self.minMaxTemperature, self.currentTemperatureLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 10
        return stackView
    }()

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.iconImageView, self.verticalStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 15
        return stackView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setHorizontalStackView()
        setImageIconView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDateAndTemperature() {
        guard let currentWeatherData = WeatherDataHolder.shared.current else {
            print("\(#function)에 들어갈 데이터가 없습니다.")
            return
        }
        
        let maxTem = currentWeatherData.main.temperatureMaximum
        let minTem = currentWeatherData.main.temperatureMinimum
        let currentTem = currentWeatherData.main.currentTemperature
        
        let convertedCurentTem = TemperatureConverter(celciusTemperature: currentTem).convertedTemperature
        let convertedmaxTem = TemperatureConverter(celciusTemperature: maxTem).convertedTemperature
        let convertedminTem = TemperatureConverter(celciusTemperature: minTem).convertedTemperature
        
        self.minMaxTemperature.text = "최고 \(convertedmaxTem)° 최저 \(convertedminTem)°"
        self.currentTemperatureLabel.text = "\(convertedCurentTem)"
    }
    
    func configureIconImage(_ image: UIImage) {
        self.iconImageView.image = image
        self.iconImageView.contentMode = .scaleAspectFit
    }
    
    func confifureAddress(_ address: String) {
        self.addressLabel.text = address
    }
}

extension OpenWeatherHeaderView {
    private func setHorizontalStackView() {
        self.contentView.addSubview(horizontalStackView)
        setDynamicType(to: self.addressLabel, .body)
        setDynamicType(to: self.minMaxTemperature, .body)
        setDynamicType(to: self.currentTemperatureLabel, .title1)
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setImageIconView() {
        NSLayoutConstraint.activate([
            iconImageView
                .widthAnchor
                .constraint(equalTo: horizontalStackView.widthAnchor,
                                                 multiplier: 0.2),
            iconImageView
                .heightAnchor
                .constraint(equalTo: horizontalStackView.heightAnchor),
            iconImageView
                .leadingAnchor
                .constraint(equalTo: horizontalStackView.leadingAnchor,
                            constant: 10),
            iconImageView.topAnchor.constraint(equalTo: horizontalStackView.topAnchor)
        ])
    }
    
    private func setDynamicType(to label: UILabel, _ font: UIFont.TextStyle) {
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: font)
    }
}


