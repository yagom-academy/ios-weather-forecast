//
//  WeatherForecastError.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/20.
//

import Foundation

enum WeatherForecastError: LocalizedError {
    case failGetCurrentLocation
    case failTransportData
    case failFetchData
    case failMatchingMimeType
    case failGetData
    case failDecode
    case failGetAuthorization
    
    var errorDescription: String? {
        switch self {
        case .failTransportData:
            return "클라이언트에서 데이터를 보내는데 실패하였습니다."
        case .failMatchingMimeType:
            return "가져오려는 데이터 타입이 일치하지 않습니다."
        case .failGetCurrentLocation:
            return "현재 위치 좌표 가져오는데 실패하였습니다."
        case .failFetchData:
            return "서버에서 데이터를 가져오는데 실패하였습니다."
        case .failGetData:
            return "데이터를 가져오는데 실패하였습니다."
        case .failDecode:
            return "데이터를 디코딩하는데 실패하였습니다."
        case .failGetAuthorization:
            return "사용자 위치 권한을 승인받는데 실패하였습니다."
        }
    }
}
