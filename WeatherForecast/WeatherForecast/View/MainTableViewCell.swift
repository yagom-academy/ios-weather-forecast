//
//  MainTableViewCell.swift
//  WeatherForecast
//
//  Created by Yongwoo Marco on 2021/10/13.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    private let containView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .label
        label.font = .preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    private var temperatureLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .label
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    private var weatherIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        self.contentView.addSubview(containView)
        containView.addArrangedSubview(dateLabel)
        containView.addArrangedSubview(temperatureLabel)
        containView.addArrangedSubview(weatherIconImage)
                
        NSLayoutConstraint.activate([
            weatherIconImage.widthAnchor.constraint(equalToConstant: 50),
            weatherIconImage.widthAnchor.constraint(equalToConstant: 50),
            
            containView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            containView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8.0),
            containView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 8.0),
            containView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ date: String, temperature: String, image: String) {
        dateLabel.text = date
        temperatureLabel.text = temperature
//        weatherIconImage.image = image
    }

}
