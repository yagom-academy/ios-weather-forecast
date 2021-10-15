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
        self.translatesAutoresizingMaskIntoConstraints = false
        
        containView.addArrangedSubview(dateLabel)
        containView.addArrangedSubview(temperatureLabel)
        containView.addArrangedSubview(weatherIconImage)
        
        self.contentView.addSubview(containView)
        
        NSLayoutConstraint.activate([
            weatherIconImage.heightAnchor.constraint(equalToConstant: 30),
            weatherIconImage.widthAnchor.constraint(equalToConstant: 30),
            
            containView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0),
            containView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8.0),
            containView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 8.0)
//            containView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 8.0)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherIconImage.image = nil
    }
    
    func configureTexts(_ date: String, temperature: String) {
        dateLabel.text = date
        temperatureLabel.text = temperature
    }
    
    func configureIcon(image: UIImage) {
        weatherIconImage.image = image
    }
}
