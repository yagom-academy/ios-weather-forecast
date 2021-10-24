//
//  WeatherForecastTests - WeatherForecastTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import WeatherForecast

class WeatherForecastTests: XCTestCase {
    
    let parsingManager = ParsingManager()
    
    func test_json파일인CurrentWeather를_디코딩했을때_디코딩에성공한다() {
        //given
        var outputValue: Int?
        let expectedValue = 420006353
        let path = Bundle(for: type(of: self)).path(forResource: "CurrentWeather", ofType: "json")
        let jsonFile = try! String(contentsOfFile: path!).data(using: .utf8)
        //when
        let data = parsingManager.parse(jsonFile!, to: CurrentWeather.self)
        switch data {
        case .success(let currentWeather):
            outputValue = currentWeather.id
        case .failure(_):
            outputValue = nil
        }
        //then
        XCTAssertEqual(expectedValue, outputValue)
    }
    
    func test_json파일인FiveDayForecast를_디코딩했을때_디코딩에성공한다() {
        //given
        var outputValue: Int?
        let expectedValue = 2643743
        let path = Bundle(for: type(of: self)).path(forResource: "FiveDayWeather", ofType: "json")
        let jsonFile = try! String(contentsOfFile: path!).data(using: .utf8)
        //when
        let data = parsingManager.parse(jsonFile!, to: FiveDayForecast.self)
        switch data {
        case .success(let fiveDayWeather):
            outputValue = fiveDayWeather.city.id
        case .failure(_):
            outputValue = nil
        }
        //then
        XCTAssertEqual(expectedValue, outputValue)
    }
    
    func test_mockURLSession에성공조건을주고_실제통신없이request했을때_request메서드성공한다() {
        //given
        let path = Bundle(for: type(of: self)).path(forResource: "CurrentWeather", ofType: "json")
        let jsonFile = try! String(contentsOfFile: path!).data(using: .utf8)
        let session = MockURLSession(isSuccess: true)
        let networkManager = NetworkManager<WeatherRequest>(session: session)
        var outputValue: Data?
        let expectedValue = jsonFile
        
        //when
        networkManager.request(WeatherRequest.getCurrentWeather(latitude: 123, longitude: 123)) { result in
            switch result {
            case .success(let data):
                outputValue = data
            case .failure:
                outputValue = nil
            }
        }
        
        // then
        XCTAssertEqual(expectedValue, outputValue)
    }
    
    func test_mockURLSession에실패조건을주고_실제통신없이request했을때_에러가발생한다() {
        //given
        let session = MockURLSession(isSuccess: false)
        let networkManager = NetworkManager<WeatherRequest>(session: session)
        var outputValue: NetworkError?
        let expectedValue = NetworkError.failedStatusCode
        
        //when
        networkManager.request(WeatherRequest.getCurrentWeather(latitude: 123, longitude: 123)) { result in
            switch result {
            case .success:
                outputValue = nil
            case .failure(let error):
                outputValue = error
            }
        }
        
        //then
        XCTAssertEqual(expectedValue, outputValue)
    }
    
    func test_실제네트워크통신조건에서_request했을때_서버에서데이터를받아온다() {
        // given
        var outputValue: String?
        let expectedValue = "Banpobondong"
        let networkManager = NetworkManager<WeatherRequest>()
        let expectation = XCTestExpectation()
        // when
        networkManager.request(WeatherRequest.getCurrentWeather(latitude: 37.478055, longitude: 126.961595)) { result in
            switch result {
            case .success(let data):
                let parsedData = self.parsingManager.parse(data, to: CurrentWeather.self)
                switch parsedData {
                case .success(let curretWeather):
                    outputValue = curretWeather.name
                case .failure:
                    XCTFail()
                }
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        // then
        XCTAssertEqual(outputValue, expectedValue)
    }
    
    func test_실제네트워크통신에서_잘못된request를했을때_에러가발생한다() {
        // given
        var outputValue: NetworkError?
        let expectedValue = NetworkError.failedStatusCode
        let networkManager = NetworkManager<WeatherRequest>()
        let invalidRequest = WeatherRequest.getCurrentWeather(latitude: 0.1, longitude: 900.1)
        let expectation = XCTestExpectation()
        // when
        networkManager.request(invalidRequest) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                outputValue = error
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        // then
        XCTAssertEqual(outputValue, expectedValue)
    }
}
