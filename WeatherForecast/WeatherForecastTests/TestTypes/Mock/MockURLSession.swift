//
//  MockURLSession.swift
//  WeatherForecastTests
//
//  Created by Marco, Soll on 2021/10/01.
//

import Foundation
@testable import WeatherForecast

struct MockURLSession: URLSessionProtocol {
    private let mockURLSessionDataTask: MockURLSessionDataTask = MockURLSessionDataTask()
    private let isSuccess: Bool
    
    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let successResponse = HTTPURLResponse(url: url,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)
        let failureResponse = HTTPURLResponse(url: url,
                                              statusCode: 400,
                                              httpVersion: nil,
                                              headerFields: nil)
        mockURLSessionDataTask.resumeDidCall = {
            completionHandler(nil, self.isSuccess ? successResponse : failureResponse, nil)
        }
        
        return mockURLSessionDataTask
    }
}
