//
//  FiveDaysForcecastCell.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/11.
//

import UIKit

struct CellHolder {
    let dateLabelText: String?
    let temperatureText: String?
    var iconImage: UIImage?
}

class FiveDaysForcecastCell: UITableViewCell {

    func configure(_ holder: CellHolder) {
        self.dateLabel.text = holder.dateLabelText
        self.temperatureLabel.text = holder.temperatureText
        self.weatherIconImageView.image = holder.iconImage
    }
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textColor = .black
        dateLabel.textAlignment = .center
        dateLabel.adjustsFontForContentSizeCategory = true
        
        return dateLabel
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.textColor = .black
        tempLabel.textAlignment = .center
        tempLabel.adjustsFontForContentSizeCategory = true
        
        return tempLabel
    }()
    
    private lazy var weatherIconImageView: UIImageView = {
        let weatherIcon = UIImageView()
        if let placeHolderImage = UIImage(named: "cat") {
            weatherIcon.image = placeHolderImage
            return weatherIcon
        }
        return UIImageView()
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.dateLabel, self.temperatureLabel, self.weatherIconImageView])
        
        stackView.axis = .horizontal
        self.contentView.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        
        stackView.distribution = .fill
        stackView.alignment = .center
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
