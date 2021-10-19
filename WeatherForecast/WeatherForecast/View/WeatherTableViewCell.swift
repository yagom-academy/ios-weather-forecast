//
//  WeatherTableViewCell.swift
//  WeatherForecast
//
//  Created by Dasoll Park on 2021/10/19.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    var dateLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        return label
    }()
    var temperatureLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        return label
    }()
    var weatherImageView: UIImageView = {
        var image = UIImageView()
        image.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        image.contentMode = UIView.ContentMode.scaleAspectFit
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(weatherImageView)
        setUpAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    private func setUpAutoLayout() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            dateLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            weatherImageView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16),
            weatherImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            temperatureLabel.rightAnchor.constraint(equalTo: weatherImageView.leftAnchor, constant: -8),
            temperatureLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
