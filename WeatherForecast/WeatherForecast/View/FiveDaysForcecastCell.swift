//
//  FiveDaysForcecastCell.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/11.
//

import UIKit

class FiveDaysForcecastCell: UITableViewCell {

    private lazy var dateLabel = UILabel()
    private lazy var temperatureLabel = UILabel()
    private lazy var weatherIconImageView = UIImageView()
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
