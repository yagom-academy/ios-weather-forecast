//
//  WeatherForecastTests - WeatherForecastTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import WeatherForecast

class WeatherForecastTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_currentweather_jsonType() throws {
        guard let url = Bundle.main.url(forResource: "Current", withExtension: "json") else {
            XCTFail()
            return
        }
        let data = try Data(contentsOf: url)
        do {
            let currentWeather = try JSONDecoder().decode(CurrentWeather.self, from: data)
            XCTAssertEqual(currentWeather.cityID, 420006353)
            XCTAssertEqual(currentWeather.locationDegree.latitude, 37.39)
            XCTAssertEqual(currentWeather.weather?.id, 800)
        } catch {
            XCTFail()
        }
    }
    
    func test_ForecastFiveDays_jsonType() throws {
        guard let url = Bundle.main.url(forResource: "FiveDays", withExtension: "json") else {
            XCTFail()
            return
        }
        let data = try Data(contentsOf: url)
        do {
            let forecastFiveDays = try JSONDecoder().decode(ForecastFiveDays.self, from: data)
            XCTAssertEqual(forecastFiveDays.numberOfTimeStamp, 40)
            XCTAssertEqual(forecastFiveDays.forecastList[0].dataTimeText, "2020-08-04 18:00:00")
        } catch {
            XCTFail()
        }
    }

}
