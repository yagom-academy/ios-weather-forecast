//
//  WeatherNetworkManagerTests.swift
//  WeatherForecastTests
//
//  Created by Yongwoo Marco on 2021/10/01.
//

import XCTest
@testable import WeatherForecast

class WeatherNetworkManagerTests: XCTestCase {
    
    var successSut: WeatherNetworkManager!
    var failureSut: WeatherNetworkManager!

    override func setUp() {
        super.setUp()
        successSut = WeatherNetworkManager(session: MockURLSession(isSuccess: true))
        failureSut = WeatherNetworkManager(session: MockURLSession(isSuccess: false))
    }

    override func tearDown() {
        successSut = nil
        failureSut = nil
        super.tearDown()
    }
    
    func test_success_fetchData메서드통신성공하면_completion_success결과매개변수반환() {
        // give
        let anyURL = URL(string: "www.yagom.net")
        // when
        successSut.fetchData(with: anyURL!) { result in
            // then
            switch result {
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTAssert(false)
            }
        }
    }
    
    func test_failure_fetchData메서드통신실패하면_completion_failure결과매개변수반환() {
        // give
        let anyURL = URL(string: "www.yagom.net")
        // when
        failureSut.fetchData(with: anyURL!) { result in
            // then
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(_):
                XCTAssert(true)
            }
        }
    }
}
