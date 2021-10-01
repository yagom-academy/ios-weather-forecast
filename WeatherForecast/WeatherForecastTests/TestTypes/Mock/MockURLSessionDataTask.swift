//
//  MockURLSessionDataTask.swift
//  WeatherForecastTests
//
//  Created by Marco, Soll on 2021/10/01.
//

import Foundation
@testable import WeatherForecast

class MockURLSessionDataTask: URLSessionDataTask {
    
    var resumeDidCall: () -> Void = {}
    
    override func resume() {
        resumeDidCall()
    }
}
