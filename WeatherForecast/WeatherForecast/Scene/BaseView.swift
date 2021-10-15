//
//  baseView.swift
//  WeatherForecast
//
//  Created by WANKI KIM on 2021/10/15.
//

import UIKit

class BaseView: UIView {
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
    
    func setup() { }
    
    func setupUI() {
        self.backgroundColor = .clear
    }
}

