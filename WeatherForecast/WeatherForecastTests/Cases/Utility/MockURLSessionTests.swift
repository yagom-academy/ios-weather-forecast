//
//  MockURLSessionTests.swift
//  WeatherForecastTests
//
//  Created by Marco, Soll on 2021/10/01.
//

import XCTest
@testable import WeatherForecast

class MockURLSessionTests: XCTestCase {
    
    var successSut: URLSessionProtocol!
    var failureSut: URLSessionProtocol!

    override func setUpWithError() throws {
        super.setUp()
        successSut = MockURLSession(isSuccess: true)
        failureSut = MockURLSession(isSuccess: false)
    }

    override func tearDownWithError() throws {
        successSut = nil
        failureSut = nil
        super.tearDown()
    }

    func test_SuccessCase_dataTask메서드로_통신성공하면_statusCode가_200이상300미만이다() {
        // given
        let successRange = 200..<300
        let url: URL! = URL(string: "https://yagom.com")
        // when
        successSut.dataTask(with: url) { _, response, _ in
            guard let response = response as? HTTPURLResponse else {
                XCTFail("Response error.")
                return
            }
            // then
            XCTAssert(successRange.contains(response.statusCode))
        }.resume()
    }
    
    func test_FailureCase_dataTask메서드로_통신실패하면_statusCode가_200이상300미만이아니다() {
        // given
        let successRange = 200..<300
        let url: URL! = URL(string: "https://yagom.com")
        // when
        failureSut.dataTask(with: url) { _, response, _ in
            guard let response = response as? HTTPURLResponse else {
                XCTFail("Response error.")
                return
            }
            // then
            XCTAssert(!successRange.contains(response.statusCode))
        }.resume()
    }
}
