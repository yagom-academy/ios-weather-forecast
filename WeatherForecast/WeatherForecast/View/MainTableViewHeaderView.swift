//
//  MainTableViewHeaderView.swift
//  WeatherForecast
//
//  Created by Yongwoo Marco on 2021/10/14.
//

import UIKit

final class MainTableViewHeaderView: UIView {
    private let containView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let currentDataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return stackView
    }()
    private var weatherIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var addressLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .label
        label.font = .preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.text = " - "
        return label
    }()
    private var temperatureRangeLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .label
        label.font = .preferredFont(forTextStyle: .body)
        label.text = " - "
        return label
    }()
    private var currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .label
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = " - "
        return label
    }()
    private let changeLocationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.titleLabel?.textColor = .label
        button.setTitle("위치변경", for: .normal)
        return button
    }()
    
    convenience init(backgroundColor: UIColor) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        setUpViewLayout()
        setUpConstraints()
    }
}

// MARK: - Private 메서드
extension MainTableViewHeaderView {
    private func setUpViewLayout() {
        currentDataStackView.addArrangedSubview(addressLabel)
        currentDataStackView.addArrangedSubview(temperatureRangeLabel)
        currentDataStackView.addArrangedSubview(currentTemperatureLabel)
        
        self.addSubview(currentDataStackView)
    
        containView.addArrangedSubview(weatherIconImage)
        containView.addArrangedSubview(currentDataStackView)
        containView.addArrangedSubview(changeLocationButton)
        
        self.addSubview(containView)
    }
    
    private func setUpConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containView.topAnchor.constraint(equalTo: self.topAnchor),
            containView.leftAnchor.constraint(equalTo: self.leftAnchor),
            containView.rightAnchor.constraint(equalTo: self.rightAnchor),
            containView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        self.layoutIfNeeded()
    }
}

// MARK: - Internal 메서드
extension MainTableViewHeaderView {
    func addChangeLocationButtonTarget(target: NSObject, action: Selector, for event: UIControl.Event) {
        changeLocationButton.addTarget(target, action: action, for: event)
    }
    
    func configureTexts(address: String, temperatureRange: String, temperature: String) {
        addressLabel.text = address
        temperatureRangeLabel.text = temperatureRange
        currentTemperatureLabel.text = temperature
    }
    
    func configureIcon(image: UIImage) {
        weatherIconImage.image = image
        
        let height = calculateHeaderHeight()
        NSLayoutConstraint.activate([
            weatherIconImage.heightAnchor.constraint(equalToConstant: height),
            weatherIconImage.widthAnchor.constraint(equalToConstant: height)
        ])
        self.layoutIfNeeded()
    }
    
    func calculateHeaderHeight() -> CGFloat {
        var sumOfHeights: CGFloat = 0
        sumOfHeights += addressLabel.bounds.height
        sumOfHeights += temperatureRangeLabel.bounds.height
        sumOfHeights += currentTemperatureLabel.bounds.height
        sumOfHeights += 16
        return sumOfHeights
    }
}
