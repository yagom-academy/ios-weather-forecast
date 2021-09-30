//
//  WeatherForecastTests - WeatherForecastTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import WeatherForecast

class WeatherForecastTests: XCTestCase {
    
    let parsingManager = ParsingManager()
    
    func test_JSON파일인CurrentWeather를_디코딩했을때_id는420006353이다() {
        //given
        let outputValue: Int?
        let expectedValue = 420006353
        let path = Bundle(for: type(of: self)).path(forResource: "CurrentWeather", ofType: "json")
        let jsonFile = try! String(contentsOfFile: path!).data(using: .utf8)
        //when
        let data = parsingManager.parse(jsonFile!, to: CurrentWeather.self)
        switch data {
        case .success(let currentWeather):
            outputValue = currentWeather.id
        case .failure(_):
            outputValue = -1
        }
        //then
        XCTAssertEqual(expectedValue, outputValue)
    }
    
    func test_JSON파일인FiveDayWeather를_디코딩했을때_id는2643743이다() {
        //given
        let outputValue: Int?
        let expectedValue = 2643743
        let path = Bundle(for: type(of: self)).path(forResource: "FiveDayWeather", ofType: "json")
        let jsonFile = try! String(contentsOfFile: path!).data(using: .utf8)
        //when
        let data = parsingManager.parse(jsonFile!, to: FiveDayForecast.self)
        switch data {
        case .success(let fiveDayWeather):
            outputValue = fiveDayWeather.city.id
        case .failure(_):
            outputValue = -1
        }
        //then
        XCTAssertEqual(expectedValue, outputValue)
    }
    
    func test() {
        
    }
}
