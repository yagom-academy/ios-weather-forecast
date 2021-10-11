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
    
    func test_JSON파일인FiveDayWeather를_디코딩했을때_id는2643743이다() {
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
    
    func test_mock통신이_성공한다() {
        //given
        let path = Bundle(for: type(of: self)).path(forResource: "CurrentWeather", ofType: "json")
        let jsonFile = try! String(contentsOfFile: path!).data(using: .utf8)
        let session = MockURLSession(isSuccess: true, data: jsonFile)
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
    
    func test_mock통신이_실패한다() {
        //given
        let path = Bundle(for: type(of: self)).path(forResource: "CurrentWeather", ofType: "json")
        let jsonFile = try! String(contentsOfFile: path!).data(using: .utf8)
        let session = MockURLSession(isSuccess: false, data: jsonFile)
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
    
    func test_NetworkManager를통해_실제네트워크통신을했을때_name은Banpobondong이다() {
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
    
    func test_잘못된Request를하면_실제네트워크통신을했을때_네트워크에러가발생한다() {
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
