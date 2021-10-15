//
//  MainViewTableViewCell.swift
//  WeatherForecast
//
//  Created by kjs on 2021/10/15.
//

import UIKit

class MainViewTableViewCell: UITableViewCell {
    static let identifier = "MainViewTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("Error: cell is created on wrong way, Do not use interface builder")
    }
}
