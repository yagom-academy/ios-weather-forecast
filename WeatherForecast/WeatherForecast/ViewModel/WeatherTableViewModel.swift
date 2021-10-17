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
    func setHederViewContents(_ viewModel: WeatherHeaderModel?)
    func setTableViewRows(_ count: Int)
}

final class WeatherTableViewModel: ViewModel {
    typealias Input = WeatherViewModelAction
    typealias Output = WeatherViewModelDelegete
    
    weak var delegate: Output?
    
    private let service = WeatherService.shared
    private var weatherCurrent: WeatherHeaderModel? {
        didSet {
            delegate?.setHederViewContents(self.weatherCurrent)
        }
    }
    private var weatherFiveDays = [WeatherCellModel]() {
        didSet {
            delegate?.setTableViewRows(self.weatherFiveDays.count)
        }
    }
    
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
    
    func getCellViewModel(at indexPath: IndexPath) -> WeatherCellModel {
        return weatherFiveDays[indexPath.row]
    }
}

// MARK: - WeatherServiceDelegate
extension WeatherTableViewModel: WeatherServiceDelegate {
    func didUpdatedWeatherDatas(current: CurrentWeather?, forecast: FiveDaysWeather?) {
  
        let currentTempature = String.formattingTempature(current?.main.temp)
        let maxTempature = String.formattingTempature(current?.main.tempMax)
        let minTempature = String.formattingTempature(current?.main.tempMin)
        service.getAddress { adress in
            self.weatherCurrent = WeatherHeaderModel(address: adress,
                                                minTempature: minTempature ?? "",
                                                maxTempature: maxTempature ?? "",
                                                currentTempature: currentTempature ?? "",
                                                iconImage: current?.iconImage)
        }
        
        var cellViewModel =  [WeatherCellModel]()
        
        forecast?.list.forEach { weather in
            let dateText = String.convertFormatteText(weather.forecastTime)
            let tempature = String.formattingTempature(weather.main.temp)
            
            guard let iconPath = weather.weather.first?.icon else { return }
            let cellModel = WeatherCellModel(weatherDateText: dateText,
                                             tempature: tempature ?? "",
                                             iconPath: iconPath)
            
            cellViewModel.append(cellModel)
        }
        
        self.weatherFiveDays = cellViewModel
    }
}
