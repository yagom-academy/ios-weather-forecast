//
//  WeatherForecastTests - WeatherForecastTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import WeatherForecast

class WeatherForecastTests: XCTestCase {
    
    let decoder = JSONDecoder()
    let bundle = Bundle(for: WeatherForecastTests.self)
    
    func testDecodeCurrentWeatherResponseJSON() {
        let fileName = "CurrentWeatherResponse"
        
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            XCTFail("URL Error")
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Data Error")
            return
        }
        
        do {
            let result = try decoder.decode(CurrentWeather.self, from: data)
            print(result)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDecodeFiveDayForecastResponseJSON() {
        let fileName = "FiveDayForecastResponse"
        
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            XCTFail("URL Error")
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Data Error")
            return
        }
        
        do {
            let result = try decoder.decode(FiveDayForecast.self, from: data)
            print(result)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    struct DummyWeatherAPIManagerDelegate: WeatherAPIManagerDelegate {
        let testExpectation: XCTestExpectation
        
        func setCurrentWeather(from response: CurrentWeather) {
            print(response)
            testExpectation.fulfill()
        }
        
        func setFiveDayForecast(from response: FiveDayForecast) {
            print(response)
            testExpectation.fulfill()
        }
    }
    
    func testRequestCurrentWeather() {
        let testExpectation = expectation(description: "Success")
        let dummy = DummyWeatherAPIManagerDelegate(testExpectation: testExpectation)
        var weatherAPIManager = WeatherAPIManager()
        weatherAPIManager.delegate = dummy
        weatherAPIManager.request(information: .CurrentWeather, latitude: 37.5665, logitude: 126.9779)
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testRequestFiveDayForecast() {
        let testExpectation = expectation(description: "Success")
        let dummy = DummyWeatherAPIManagerDelegate(testExpectation: testExpectation)
        var weatherAPIManager = WeatherAPIManager()
        weatherAPIManager.delegate = dummy
        weatherAPIManager.request(information: .FiveDayForecast, latitude: 37.5665, logitude: 126.9779)
        wait(for: [testExpectation], timeout: 5)
    }

}
