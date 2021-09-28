//
//  WeatherForecastTests - WeatherForecastTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import WeatherForecast

class WeatherForecastTests: XCTestCase {
    
    let parsingManager = ParsingManager()
    
    func test() {
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
}

//error message
//Constant 'outputValue' captured by a closure before being initialized
