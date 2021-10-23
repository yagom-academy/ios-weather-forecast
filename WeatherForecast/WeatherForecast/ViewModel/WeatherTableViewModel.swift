//
//  WeatherTableViewModel.swift
//  WeatherForecast
//
//  Created by KimJaeYoun on 2021/10/15.
//

import Foundation

enum WeatherViewModelAction {
    case refresh
}

protocol WeatherViewModelDelegete: AnyObject {
    func setViewContents(_ current: CurrentWeather?, _ fiveDays: FiveDaysWeather?)
}

final class WeatherTableViewModel: ViewModel {
    typealias Input = WeatherViewModelAction
    typealias Output = WeatherViewModelDelegete
    
    weak var delegate: Output?
    
    private let service = WeatherService.shared
    
    init() {
        service.delegate = self
    }
}

// MARK: - Method
extension WeatherTableViewModel {
    func action(_ action: Input) {
        switch action {
        case .refresh:
            service.refreshData()
        }
    }
}

// MARK: - WeatherServiceDelegate
extension WeatherTableViewModel: WeatherServiceDelegate {
    func didUpdatedWeatherDatas(current: CurrentWeather?, fiveDays: FiveDaysWeather?) {
        delegate?.setViewContents(current, fiveDays)
    }
}
