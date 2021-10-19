//
//  WeatherForecastTests - WeatherForecastTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import WeatherForecast

class WeatherForecastTests: XCTestCase {
    let decoder = Parser()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_TodayWeatherInfo모델_디코딩이성공하면_같은temperature값이나온다() {
        guard let jsonData = TodayWeatherInfo.mock.data(using: .utf8) else {
                  return XCTFail()
              }

        do {
            let result: TodayWeatherInfo = try decoder.decode(jsonData)
            XCTAssertEqual(282.55, result.main?.temperature)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func test_WeeklyWeatherInfo모델_디코딩이성공하면_같은temperature값이나온다() {
        guard let jsonData = WeeklyWeatherForecast.mock.data(using: .utf8) else {
                  return XCTFail()
              }

        do {
            let result: WeeklyWeatherForecast = try decoder.decode(jsonData)
            XCTAssertEqual(293.55, result.list?.first?.main?.temperature)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

