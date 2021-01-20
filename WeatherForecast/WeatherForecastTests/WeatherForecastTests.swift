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
            XCTFail("\(error.localizedDescription)")
        }
    }
    
    func testDecodeResponseDataOfWeatherForecastAPI() {
        // Given-When-Then (준비-실행-검증)
        // Given
        guard let dataAsset = NSDataAsset(name: "ExampleResponseOfWeatherForecast") else {
            XCTFail("Failed to load dataAsset")
            return
        }
        let jsonDecoder = JSONDecoder()
        let decodedData: WeatherForecast
            
        do {
            // When
            decodedData = try jsonDecoder.decode(WeatherForecast.self, from: dataAsset.data)
            
            // Then
            XCTAssertEqual(decodedData.count, 3)
            for i in 0..<3 {
                XCTAssertEqual(decodedData.list[i].utc, 1596564000)
                XCTAssertEqual(decodedData.list[i].temperature.current, 293.55)
                XCTAssertEqual(decodedData.list[i].temperature.humanFeels, 293.13)
                XCTAssertEqual(decodedData.list[i].temperature.minimum, 293.55)
                XCTAssertEqual(decodedData.list[i].temperature.maximum, 294.05)
                XCTAssertEqual(decodedData.list[i].temperature.atmosphericPressure, 1013)
                XCTAssertEqual(decodedData.list[i].temperature.humidity, 84)
                XCTAssertEqual(decodedData.list[i].weather.conditionID, 500)
                
                XCTAssertEqual(decodedData.list[i].weather.group, "Rain")
                XCTAssertEqual(decodedData.list[i].weather.description, "light rain")
                XCTAssertEqual(decodedData.list[i].weather.iconID, "10d")
                XCTAssertEqual(decodedData.list[i].dateTimeString, "2020-08-04 18:00:00")
            }
            XCTAssertEqual(decodedData.city.id, 2643743)
            XCTAssertEqual(decodedData.city.name, "London")
            XCTAssertEqual(decodedData.city.coordinate.latitude, 51.5073)
            XCTAssertEqual(decodedData.city.coordinate.longitude, -0.1277)
        } catch {
            XCTFail("\(error.localizedDescription)")
        }
    }
}
