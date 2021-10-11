//
//  MainWeatherTableViewCell.swift
//  WeatherForecast
//
//  Created by JINHONG AN on 2021/10/11.
//

import UIKit

final class MainWeatherTableViewCell: UITableViewCell {
    static let identifier = "MainWeatherTableViewCell"
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        
        return stackView
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    
        return label
    }()
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
