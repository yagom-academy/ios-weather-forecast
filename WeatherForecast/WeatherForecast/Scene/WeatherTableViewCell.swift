//
//  WeatherTableViewCell.swift
//  WeatherForecast
//
//  Created by WANKI KIM on 2021/10/17.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    private enum Constraint {
        static let inset: CGFloat = 10
    }
    static let reuseIdentifier = "\(WeatherTableViewCell.self)"
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        applyViewSetting()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        applyViewSetting()
    }
}

extension WeatherTableViewCell: ViewConfiguration {
    func buildHerarchy() {
        contentView.addSubViews(iconImageView, dateLabel, temperatureLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constraint.inset),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constraint.inset),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constraint.inset),
            
            temperatureLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo: dateLabel.trailingAnchor,
                constant: Constraint.inset),
            temperatureLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constraint.inset),
            temperatureLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constraint.inset),
            temperatureLabel.trailingAnchor.constraint(
                equalTo: iconImageView.leadingAnchor,
                constant: -Constraint.inset),
            
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constraint.inset),
            
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor)
        ])
    }
}

extension WeatherTableViewCell {
    func configure(with forecast: WeatherForecast?) {
        forecast?.localeForecast
            .flatMap { self.dateLabel.text = $0 }
        
        forecast
            .flatMap { $0.main?.convertToCelsius(with: $0.main?.temperature) }
            .flatMap { self.temperatureLabel.text = "\($0)°" }
        
        forecast?.weather?.first?.icon
            .flatMap { configureImage(with: $0) }
    }
    
    func configureImage(with urlString: String) {
        let url = URLGenerator().generateImageURL(with: urlString)
        imageLoader.loadImage(from: url) { image in
            imageCache.add(image, forKey: url)
            DispatchQueue.main.async {
                self.iconImageView.image = image
            }
        }
    }
}
