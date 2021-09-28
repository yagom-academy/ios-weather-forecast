//
//  WeatherForecastTests - WeatherForecastTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import WeatherForecast

class WeatherForecastTests: XCTestCase {
    func test_CurrentWeather파일을_parse메서드로디코딩을했을떄_Sys의country는KR이다() {
        //Given
        let testFileName = "CurrentWeather"
        let testDataType = CurrentWeather.self
        guard let testData = NSDataAsset(name: testFileName)?.data else {
            return XCTFail("\(testFileName)파일이 잘못되었습니다.")
        }
        let expectedValue = "KR"
        
        //When
        let parsedResult = testData.parse(to: testDataType)
        
        //Then
        switch parsedResult {
        case .success(let decodedData):
            XCTAssertEqual(decodedData.sys.country, expectedValue)
        default:
            XCTFail("디코딩에 실패했습니다.")
        }
    }
    
    func test_FiveDayWeather파일을_parse메서드로디코딩했을때_List의count는5이다() {
        //Given
        let testFileName = "FiveDayWeather"
        let testDataType = FiveDayWeather.self
        guard let testData = NSDataAsset(name: testFileName)?.data else {
            return XCTFail("\(testFileName)파일이 잘못되었습니다.")
        }
        let expectedValue = 40
        
        //When
        let parsedResult = testData.parse(to: testDataType)
        
        //Then
        switch parsedResult {
        case .success(let decodedData):
            XCTAssertEqual(decodedData.list.count, expectedValue)
        default:
            XCTFail("디코딩에 실패했습니다.")
        }
    }
}
