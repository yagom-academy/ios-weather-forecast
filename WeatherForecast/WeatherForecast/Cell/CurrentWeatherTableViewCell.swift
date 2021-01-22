//
//  CurrentWeatherTableViewCell.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/22.
//

import UIKit

class CurrentWeatherTableViewCell: UITableViewCell {
    
    

    lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "dd"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(title)
        title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        title.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
