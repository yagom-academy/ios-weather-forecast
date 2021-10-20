//
//  Address.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/10/15.
//

import Foundation

struct Address {
    let city: String
    let stree1: String
    
    var combined: String {
        return [self.city, self.stree1].joined(separator: " ")
    }
    
    init() {
        self.city = ""
        self.stree1 = ""
    }
    
    init(city: String, stree1: String) {
        self.city = city
        self.stree1 = stree1
    }
}
