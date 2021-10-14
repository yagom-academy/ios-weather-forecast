//
//  CustomTableViewCell.swift
//  WeatherForecast
//
//  Created by Theo on 2021/10/14.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    static let identifier = "cell"
    
    var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleToFill

        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var mininumTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        
        return stackView
    }()
    
    private func configureLayout() {
        horizontalStackView.addArrangedSubview(dateLabel)
        horizontalStackView.addArrangedSubview(mininumTemperatureLabel)
        horizontalStackView.addArrangedSubview(weatherImageView)
        contentView.addSubview(horizontalStackView)
        
            NSLayoutConstraint.activate([
                
                horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
                horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
            ])
        }
    override func setNeedsLayout() {
        self.backgroundColor = .clear
        configureLayout()
    }

}

extension UIImageView {
    open override var intrinsicContentSize: CGSize {
        super.intrinsicContentSize
        return CGSize(width: 40, height: 40)
    }
}
