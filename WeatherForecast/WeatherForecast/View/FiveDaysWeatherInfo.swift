//
//  WeatherInfoCell.swift
//  WeatherForecast
//
//  Created by yun on 2021/10/15.
//

import UIKit

final class WeatherInfoCell: UITableViewCell {
    static let cellIdentifier: String = "WeatherInfoCell"
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private func addSubViews() {
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(temperatureLabel)
        self.contentView.addSubview(weatherImageView)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weatherImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            weatherImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherImageView.widthAnchor.constraint(equalToConstant: 30),
            weatherImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.trailingAnchor.constraint(equalTo: weatherImageView.leadingAnchor, constant: -10),
            temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
