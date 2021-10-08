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
    var isSuccess: Bool
    var data: Data?
    
    init(isSuccess: Bool, data: Data?) {
        self.isSuccess = isSuccess
        self.data = data
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let data = self.data
        
        let successResponse = HTTPURLResponse(url: request.url!,
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)
        let failureResponse = HTTPURLResponse(url: request.url!,
                                              statusCode: 404,
                                              httpVersion: "2",
                                              headerFields: nil)
        
        if isSuccess {
            mockURLSessionDataTask.resumeDidCall = { completionHandler(data, successResponse, nil) }
        } else {
            mockURLSessionDataTask.resumeDidCall = { completionHandler(nil, failureResponse, nil) }
        }
        
        return mockURLSessionDataTask
    }
}
