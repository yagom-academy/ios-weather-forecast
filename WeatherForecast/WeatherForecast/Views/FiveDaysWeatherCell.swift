//
//  FiveDaysWeatherCell.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/18.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    static let identifier = String(describing: WeatherCell.self)
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let weatherStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
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
        self.layer.addBorder(edge: .bottom, color: .gray, thickness: 1)
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
    
    func configure(list: List) {
        if let date = list.dt,
           let temperature = list.main?.temp {
            dateLabel.text =
            DateFormatter().convertDate(intDate: date)
            temperatureLabel.text =
            MeasurementFormatter().convertTemperature(temp: temperature)
        }
    }
}
