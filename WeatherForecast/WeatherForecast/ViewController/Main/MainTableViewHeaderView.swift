//
//  MainTableViewHeaderView.swift
//  WeatherForecast
//
//  Created by kjs on 2021/10/15.
//

import UIKit

class MainTableViewHeaderView: UITableViewHeaderFooterView {
    static let identifier = "MainTableViewHeaderView"

    let iconView = UIImageView()
    let addressLabel = UILabel()
    let minimumTemperatureLabel = UILabel()
    let maximumTemperatureLabel = UILabel()
    let currentTemperatureLabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        layoutContents()
    }

    required init?(coder: NSCoder) {
        fatalError("Error: MainTableViewHeaderView is created on wrong way, Do not use interface builder")
    }

    private func layoutContents() {
        let temperatureStackView = UIStackView(
            arrangedSubviews: [minimumTemperatureLabel, maximumTemperatureLabel]
        )
        minimumTemperatureLabel.font = .preferredFont(forTextStyle: .caption2)
        maximumTemperatureLabel.font = .preferredFont(forTextStyle: .caption2)

        minimumTemperatureLabel.text = "최저온도"
        maximumTemperatureLabel.text = "최고온도"

        temperatureStackView.axis = .horizontal
        temperatureStackView.distribution = .fillProportionally
        temperatureStackView.alignment = .fill
        temperatureStackView.spacing = 4

        let labelStackView = UIStackView(
            arrangedSubviews: [addressLabel, temperatureStackView, currentTemperatureLabel]
        )

        addressLabel.font = .preferredFont(forTextStyle: .caption2)
        currentTemperatureLabel.font = .preferredFont(forTextStyle: .title3)

        addressLabel.text = "주소"
        currentTemperatureLabel.text = "현재온도"

        labelStackView.axis = .vertical
        labelStackView.distribution = .fillProportionally
        labelStackView.alignment = .leading
        labelStackView.spacing = 3

        let containerStackView = UIStackView(arrangedSubviews: [iconView, labelStackView])

        iconView.image = UIImage(systemName: "pencil")

        containerStackView.axis = .horizontal
        containerStackView.distribution = .fillProportionally
        containerStackView.alignment = .fill
        containerStackView.spacing = 16

        contentView.addSubview(containerStackView)

        containerStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
