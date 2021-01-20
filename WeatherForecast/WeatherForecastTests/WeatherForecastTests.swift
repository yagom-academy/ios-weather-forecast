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

    func testDecodeResponseDataOfCurrentWeatherAPI() {
        // Given-When-Then (준비-실행-검증)
        // Given
        guard let dataAsset = NSDataAsset(name: "ExampleResponseOfCurrentWeather") else {
            XCTFail("Failed to load dataAsset")
            return
        }
        let jsonDecoder = JSONDecoder()
        let decodedData: CurrentWeather
            
        do {
            // When
            decodedData = try jsonDecoder.decode(CurrentWeather.self, from: dataAsset.data)
            
            // Then
            XCTAssertEqual(decodedData.coordinate.longitude, -122.08)
            XCTAssertEqual(decodedData.coordinate.latitude, 37.39)
            
            XCTAssertEqual(decodedData.weather.conditionID, 800)
            XCTAssertEqual(decodedData.weather.group, "Clear")
            XCTAssertEqual(decodedData.weather.description, "clear sky")
            XCTAssertEqual(decodedData.weather.iconID, "01d")
            
            XCTAssertEqual(decodedData.temperature.current, 282.55)
            XCTAssertEqual(decodedData.temperature.humanFeels, 281.86)
            XCTAssertEqual(decodedData.temperature.minimum, 280.37)
            XCTAssertEqual(decodedData.temperature.maximum, 284.26)
            XCTAssertEqual(decodedData.temperature.atmosphericPressure, 1023)
            XCTAssertEqual(decodedData.temperature.humidity, 100)
            
            XCTAssertEqual(decodedData.utc, 1560350645)
            XCTAssertEqual(decodedData.cityID, 420006353)
            XCTAssertEqual(decodedData.cityName, "Mountain View")
        } catch {
            XCTFail("\(error)")
        }
    }
}
