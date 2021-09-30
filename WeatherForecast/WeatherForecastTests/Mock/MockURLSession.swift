//
//  MockURLSession.swift
//  WeatherForecastTests
//
//  Created by 오승기 on 2021/09/30.
//

import Foundation
@testable import WeatherForecast

class MockURLSession: URLSessionProtocol {
    
    let mockURLSessionDataTask = MockURLSessionDataTask()

}
