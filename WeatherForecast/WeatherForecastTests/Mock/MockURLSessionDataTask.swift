//
//  MockURLDataTask.swift
//  WeatherForecastTests
//
//  Created by 오승기 on 2021/09/30.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    
    var resumeDidCall: () -> Void = {}
    
    override func resume() {
        resumeDidCall()
    }
}
