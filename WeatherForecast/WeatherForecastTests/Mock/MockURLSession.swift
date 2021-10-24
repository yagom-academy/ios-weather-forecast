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
    
    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        let successResponse = HTTPURLResponse(url: request.url!,
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)
        let failureResponse = HTTPURLResponse(url: request.url!,
                                              statusCode: 404,
                                              httpVersion: "2",
                                              headerFields: nil)
        
        let path = Bundle(for: type(of: self)).path(forResource: "CurrentWeather", ofType: "json")
        let jsonData = try! String(contentsOfFile: path!).data(using: .utf8)
        
        if isSuccess {
            mockURLSessionDataTask.resumeDidCall = { completionHandler(jsonData, successResponse, nil) }
        } else {
            mockURLSessionDataTask.resumeDidCall = { completionHandler(nil, failureResponse, nil) }
        }
        
        return mockURLSessionDataTask
    }
}
