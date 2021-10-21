//
//  CustomTableViewCell.swift
//  WeatherForecast
//
//  Created by Theo on 2021/10/14.
//

import UIKit

class IntervalWeatherTableViewCell: UITableViewCell {
    static let identifier = "cell"
    
    var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleToFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var mininumTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension IntervalWeatherTableViewCell {
    private func configureLayout() {
        horizontalStackView.addArrangedSubview(dateLabel)
        horizontalStackView.addArrangedSubview(mininumTemperatureLabel)
        horizontalStackView.addArrangedSubview(weatherImageView)
        contentView.addSubview(horizontalStackView)
        
        NSLayoutConstraint.activate([
            
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    func cellConfiguration(data: FivedaysWeather, indexPath: IndexPath) {
        let daysWeatherData = data.list[indexPath.row]
        let formattedDate = dateFormatter.string(from: Date(timeIntervalSince1970: daysWeatherData.timeOfData))
        let minTemperature = "\(daysWeatherData.mainInfo.temperatureMin)º"
        
        guard let iconName = daysWeatherData.weather.first?.iconName else { return }
        guard let imageUrl = urlBuilder.builderImageURL(resource: urlResource, iconName: iconName) else {
            return
        }
        
        self.dateLabel.text = formattedDate
        self.mininumTemperatureLabel.text = minTemperature
        self.weatherImageView.loadImage(from: imageUrl)
        
    }
}


