//
//  TableViewHeaderView.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/22.
//

import UIKit

class TableViewHeaderView: UIView {
    let headerAddrressLabel = UILabel()
    let headerMinMaxTemperatureLabel = UILabel()
    let headerCurrentTemperatureLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewLayout()
    }
}

extension TableViewHeaderView {
    func updateAddrressLabel(to text: String) {
        headerAddrressLabel.text = text
    }
    
    func updateMinMaxTemperatureLabel(to text: String) {
        headerMinMaxTemperatureLabel.text = text
    }
    
    func updateCurrentTemperatureLabel(to text: String) {
        headerCurrentTemperatureLabel.text = text
    }
}

extension TableViewHeaderView {
    private func initViewLayout() {
        self.addSubview(headerAddrressLabel)
        self.addSubview(headerMinMaxTemperatureLabel)
        self.addSubview(headerCurrentTemperatureLabel)
        
        headerAddrressLabel.translatesAutoresizingMaskIntoConstraints = false
        headerAddrressLabel.leadingAnchor.constraint(
            equalTo: self.leadingAnchor,
            constant: 20
        ).isActive = true
        headerAddrressLabel.topAnchor.constraint(
            equalTo: self.topAnchor,
            constant: 20
        ).isActive = true
        headerAddrressLabel.textColor = .lightGray
        
        headerMinMaxTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        headerMinMaxTemperatureLabel.leadingAnchor.constraint(
            equalTo: self.leadingAnchor,
            constant: 20
        ).isActive = true
        headerMinMaxTemperatureLabel.topAnchor.constraint(
            equalTo: headerAddrressLabel.bottomAnchor,
            constant: 10
        ).isActive = true
        headerMinMaxTemperatureLabel.textColor = .lightGray

        headerCurrentTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        headerCurrentTemperatureLabel.leadingAnchor.constraint(
            equalTo: self.leadingAnchor,
            constant: 20
        ).isActive = true
        headerCurrentTemperatureLabel.topAnchor.constraint(
            equalTo: headerMinMaxTemperatureLabel.bottomAnchor,
            constant: 10
        ).isActive = true
        headerCurrentTemperatureLabel.textColor = .white
        
        headerCurrentTemperatureLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(40))
    }
}
