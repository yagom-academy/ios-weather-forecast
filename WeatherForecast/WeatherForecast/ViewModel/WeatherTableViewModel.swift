//
//  WeatherTableViewModel.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/15.
//

import Foundation

final class WeatherTableViewModel {
    private let service = WeatherService()

    var onCompleted: (() -> Void)?
}

