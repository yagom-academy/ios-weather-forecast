//
//  WeatherView.swift
//  WeatherForecast
//
//  Created by WANKI KIM on 2021/10/15.
//

import UIKit

class WeatherView: UIView {
    var forecastTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.backgroundView = UIImageView(image: UIImage(named: "mar"))
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        setupUI()
    }
    
    func setup() {
        self.addSubViews(forecastTableView)
    }
    
    func setupUI() {
        NSLayoutConstraint.activate([
            forecastTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            forecastTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            forecastTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            forecastTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
