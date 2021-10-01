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
    
    func test_FiveDayWeather파일을_parse메서드로디코딩했을때_List의count는40이다() {
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
    
    func test_위도가37경도가126인CurrentWeather를_parse메서드로디코딩을했을떄_Sys의country는KR이다() {
        //Given
        let parameters = WeatherForecastRoute.createParameters(latitude: 37, longitude: 126)
        var sut = NetworkManager()
        let expectedValue = "KR"
        let expectation = XCTestExpectation(description: "네트워크 통신")
        
        //When
        var outputValue: CurrentWeather? = nil
        sut.request(with: WeatherForecastRoute.current, queryItems: parameters, header: nil, bodyParameters: nil, httpMethod: .get, requestType: .requestWithQueryItems) { result in
            guard case .success(let data) = result,
                  case .success(let parsedData) = data.parse(to: CurrentWeather.self)
            else {
                return XCTFail()
            }
            outputValue = parsedData
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        //Then
        XCTAssertEqual(outputValue?.sys.country, expectedValue)
    }
    
    func test_위도가37경도가126인FiveDayWeather를_parse메서드로디코딩을했을떄_List의count는40이다() {
        //Given
        let parameters = WeatherForecastRoute.createParameters(latitude: 37, longitude: 126)
        var sut = NetworkManager()
        let expectedValue = 40
        let expectation = XCTestExpectation(description: "네트워크 통신")
        
        //When
        var outputValue: FiveDayWeather? = nil
        sut.request(with: WeatherForecastRoute.fiveDay, queryItems: parameters, header: nil, bodyParameters: nil, httpMethod: .get, requestType: .requestWithQueryItems) { result in
            guard case .success(let data) = result,
                  case .success(let parsedData) = data.parse(to: FiveDayWeather.self)
            else {
                return XCTFail()
            }
            outputValue = parsedData
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        //Then
        XCTAssertEqual(outputValue?.list.count, expectedValue)
    }
}
