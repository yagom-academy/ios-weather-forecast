//
//  ViewConfiguration.swift
//  WeatherForecast
//
//  Created by WANKI KIM on 2021/10/20.
//

import Foundation

protocol ViewConfiguration {
    func buildHerarchy()
    func setupConstraints()
    func configureViews()
}

extension ViewConfiguration {
    
    func configureViews() {}
    
    func applyViewSetting() {
        buildHerarchy()
        setupConstraints()
        configureViews()
    }
}

