//
//  WeatherForecastViewCell.swift
//  WeatherForecast
//
//  Created by 박태현 on 2021/10/13.
//

import UIKit

class WeatherForecastViewCell: UITableViewCell {
    static let identifier = "CustomTableViewCell"

    private let timeLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let iconImageView = UIImageView()
    private let stackView = UIStackView()
    private var number: Int!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCellLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpCellLayout() {
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

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = .none
    }
}
