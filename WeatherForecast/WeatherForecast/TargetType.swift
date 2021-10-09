//
//  TargetType.swift
//  WeatherForecast
//
//  Created by 이윤주 on 2021/10/09.
//

import Foundation

protocol TargetType {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var query: (Double, Double) { get }
    
    func configure() -> URLRequest?
}
