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
        networkManager.request(WeatherRequest.getCurrentWeather(latitude: 2, longitude: 2)) { result in
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
        networkManager.request(WeatherRequest.getCurrentWeather(latitude: 2, longitude: 2)) { result in
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
    
}
