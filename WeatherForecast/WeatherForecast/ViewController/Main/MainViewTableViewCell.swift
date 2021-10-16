//
//  MainViewTableViewCell.swift
//  WeatherForecast
//
//  Created by kjs on 2021/10/15.
//

import UIKit

class MainViewTableViewCell: UITableViewCell {
    static let identifier = "MainViewTableViewCell"
    
    let timeLabel = UILabel()
    let temperatureLabel = UILabel()
    let iconView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutContents()
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("Error: cell is created on wrong way, Do not use interface builder")
    }
    
    private func layoutContents() {
        let stackView = UIStackView(
            arrangedSubviews: [timeLabel, temperatureLabel, iconView]
        )
        
        timeLabel.font = .preferredFont(forTextStyle: .body)
        temperatureLabel.font = .preferredFont(forTextStyle: .body)
        
        timeLabel.text = "10/16(토)12시"
        temperatureLabel.text = "10"
        
        iconView.image = UIImage(systemName: "pencil")
        
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 4
        
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
