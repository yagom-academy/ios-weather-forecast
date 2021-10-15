//
//  threeHourForecastCell.swift
//  WeatherForecast
//
//  Created by 이윤주 on 2021/10/15.
//

import UIKit

class threeHourForecastCell: UITableViewCell {
    static let cellIdentifier = "\(self)"
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let weatherImageView: CustomImageVieew = {
        let imageView = CustomImageVieew()
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .trailing
        stackView.spacing = 5
        return stackView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        configureContents()
        configureStackView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension threeHourForecastCell {
    private func configureContents() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureStackView() {
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(weatherImageView)
    }
}
