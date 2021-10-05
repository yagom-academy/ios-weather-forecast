//
//  MockURLSessionDataTask.swift
//  WeatherForecastTests
//
//  Created by Marco, Soll on 2021/10/01.
//

import Foundation
@testable import WeatherForecast

struct MockURLSessionDataTask: URLSessionDataTaskProtocol {
    
    var resumeDidCall: () -> Void = {}
    
    func resume() {
        resumeDidCall()
    }
}
