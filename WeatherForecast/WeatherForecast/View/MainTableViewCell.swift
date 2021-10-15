//
//  MainTableViewCell.swift
//  WeatherForecast
//
//  Created by Yongwoo Marco on 2021/10/13.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
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
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    private var weatherIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setUpViewLayout()
        setUpConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViewLayout() {
        containView.addArrangedSubview(dateLabel)
        containView.addArrangedSubview(temperatureLabel)
        containView.addArrangedSubview(weatherIconImage)
        
        self.contentView.addSubview(containView)
    }
    
    private func setUpConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0),
            containView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8.0),
            containView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8.0)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherIconImage.image = nil
    }
    
    func configureTexts(date: String, temperature: String) {
        dateLabel.text = date
        temperatureLabel.text = temperature
    }
    
    func configureIcon(image: UIImage) {
        weatherIconImage.image = image
    }
}
