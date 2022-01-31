//
//  WeatherForecastViewCell.swift
//  WeatherForecast
//
//  Created by 박태현 on 2021/10/13.
//

import UIKit

class WeatherForecastViewCell: UITableViewCell {
    static let identifier = "CustomTableViewCell"
    private let timeLabel: UILabel = {
        let timeLabel = UILabel(color: .white)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        return timeLabel
    }()

    private let temperatureLabel: UILabel = {
        let temperatureLabel = UILabel(color: .white)
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        return temperatureLabel
    }()

    private let iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        return iconImageView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
        setUpConstraint()
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpLayout() {
        stackView.axis = .horizontal
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(iconImageView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(stackView)
    }

    private func setUpConstraint() {
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }

    func configureCell(data: ForecastWeather.List) {
        let date = Date(timeIntervalSince1970: data.dataReceivingTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        if let lang = Locale.preferredLanguages.first {
            dateFormatter.locale = Locale(identifier: lang)
        }
        timeLabel.text = dateFormatter.string(from: date)
        temperatureLabel.text = MeasurementFormatter().convertTemp(temp: data.main.temp, from: .kelvin, to: .celsius)

        if let iconID = data.weather.first?.icon {
            let iconURL = WeatherAPI.imagebaseURL + iconID + ".png"
            iconImageView.setImageURL(iconURL) { [weak self] cacheKey, image in
                guard let self = self else { return }
                if cacheKey as String == iconURL {
                    self.iconImageView.image = image
                }
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = .none
    }
}
