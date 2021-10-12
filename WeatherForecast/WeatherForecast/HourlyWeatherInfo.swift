//
//  TableViewCell.swift
//  WeatherForecast
//
//  Created by 오승기 on 2021/10/11.
//

import UIKit

class HourlyWeatherInfo: UITableViewCell {

    static let identifier = "HourlyWeatherInfo"

    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        return temperatureLabel
    }()
    
    private lazy var weatherImage: UIImageView = {
        let weatherImage = UIImageView()
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.contentMode = .scaleAspectFit
        return weatherImage
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContents() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(weatherImage)
        
        NSLayoutConstraint.activate([dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
                                     dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
                                     weatherImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 5),
                                     weatherImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5), temperatureLabel.trailingAnchor.constraint(equalTo: weatherImage.leadingAnchor, constant: 5),
                                     temperatureLabel.topAnchor.constraint(equalTo: weatherImage.topAnchor)])
    }
}
