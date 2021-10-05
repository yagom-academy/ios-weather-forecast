//
//  MockURLSession.swift
//  WeatherForecastTests
//
//  Created by Marco, Soll on 2021/10/01.
//

import Foundation
@testable import WeatherForecast

struct MockURLSession: URLSessionProtocol {
    
    private let isSuccess: Bool
    
    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    
    func makeCustomDataTask(with url: URL,
                            completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTaskProtocol {
        let successResponse = HTTPURLResponse(url: url,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)
        let failureResponse = HTTPURLResponse(url: url,
                                              statusCode: 400,
                                              httpVersion: nil,
                                              headerFields: nil)
        
        var mockURLSessionDataTask = MockURLSessionDataTask()
        mockURLSessionDataTask.resumeDidCall = {
            completionHandler(Data(), self.isSuccess ? successResponse : failureResponse, nil)
        }
        
        return mockURLSessionDataTask
    }
}
