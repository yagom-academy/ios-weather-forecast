//
//  WeatherError.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/20.
//

import Foundation

enum WeatherForcastError: Error {
    case getCoordinate
    case openSettings
    case convertURL
    case getData
    case network
    case convertWeatherData
    case unknown
}

extension WeatherForcastError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .getCoordinate:
            return "좌표를 가져오는 중 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요."
        case .openSettings:
            return "설정 화면 이동에 실패했습니다.\n잠시 후 다시 시도해 주세요."
        case .convertURL:
            return "URL 변환에 실패했습니다.\n잠시 후 다시 시도해 주세요."
        case .getData:
            return "데이터를 가져오는 중 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요."
        case .network:
            return "네트워크에 문제가 있습니다.\n잠시 후 다시 시도해 주세요."
        case .convertWeatherData:
            return "데이터를 변환하는 중 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요."
        }
    }
}
