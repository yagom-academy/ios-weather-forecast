//
//  ViewModel.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/17.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    var delegate: Output? { get set }

    func action(_ action: Input)
}
