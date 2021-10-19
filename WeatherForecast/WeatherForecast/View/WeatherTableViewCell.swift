//
//  WeatherTableViewCell.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/11.
//

import UIKit

final class WeatherTableViewCell: UITableViewCell {
    static let identifier = "WeatherTableViewCell"
    var cellId: String?
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .white
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .white
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContentsLayout()
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WeatherTableViewCell {
    private func configureContentsLayout() {
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(weatherImageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(stackView)
        
        let imageWidthSize: CGFloat = 30
        let imageHeightSize: CGFloat = 30
        let dateLabelLedingConstant: CGFloat = 10
        let stackViewTrailingConstant: CGFloat = -10
        
        NSLayoutConstraint.activate([
            weatherImageView.widthAnchor.constraint(equalToConstant: imageWidthSize),
            weatherImageView.heightAnchor.constraint(equalToConstant: imageHeightSize),
            
            dateLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: dateLabelLedingConstant),
            
            stackView.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: stackViewTrailingConstant)
        ])
    }
    
    func configure(_ viewModel: FiveDaysWeather.List) {
        self.dateLabel.text = viewModel.forecastTimeText
        self.temperatureLabel.text = viewModel.main.tempText
        
        guard let url = URL(string: viewModel.iconURL) else {
            return
        }
        
        cellId = url.lastPathComponent
        WeatherNetworkManager().weatherIconImageDataTask(url: url) { [weak self] image in
            guard self?.cellId == url.lastPathComponent else {
                return
            }
            DispatchQueue.main.async {
                self?.weatherImageView.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        dateLabel.text = nil
        temperatureLabel.text = nil
        weatherImageView.image = nil
    }
}
