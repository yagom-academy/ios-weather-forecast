//
//  WeatherForecastViewCell.swift
//  WeatherForecast
//
//  Created by 박태현 on 2021/10/13.
//

import UIKit

class WeatherForecastViewCell: UITableViewCell {
    static let identifier = "CustomTableViewCell"

    private let timeLabel = UILabel(color: .white)
    private let temperatureLabel = UILabel(color: .white)
    private let iconImageView = UIImageView()
    private let stackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCellLayout()
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpCellLayout() {
        stackView.axis = .horizontal
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(iconImageView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(stackView)

        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

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
        dateFormatter.locale = Locale(identifier: "ko_KR")
        timeLabel.text = dateFormatter.string(from: date)

        temperatureLabel.text = MeasurementFormatter().convertTemp(temp: data.main.temp, from: .kelvin, to: .celsius)

        if let iconID = data.weather.first?.icon {
            let iconURL = WeatherAPI.imagebaseURL + iconID + ".png"
            iconImageView.setImageURL(iconURL)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = .none
    }
}
