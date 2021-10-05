//
//  DecodingTests.swift
//  WeatherForecastTests
//
//  Created by Marco, Soll on 2021/10/01.
//

import XCTest
@testable import WeatherForecast

class DecodingTests: XCTestCase {
    
    var currentSut: CurrentWeatherData!
    var fivedaySut: FiveDayWeatherData!

    override func setUpWithError() throws {
        super.setUp()
        let currentData = try getData(fromJSON: "MockCurrentData")
        self.currentSut = try JSONDecoder().decode(CurrentWeatherData.self, from: currentData)
        let fivedayData = try getData(fromJSON: "MockFiveDayData")
        self.fivedaySut = try JSONDecoder().decode(FiveDayWeatherData.self, from: fivedayData)
    }

    override func tearDownWithError() throws {
        currentSut = nil
        fivedaySut = nil
        super.tearDown()
    }
    
    // MARK: - CurrentWeatherData 모델 디코딩 테스트
    func test_SuccessCase_CurrentData타입은_decoding된다() {
        // give
        let comparedProperty = "01d"
        // when
        let decodedProperty = currentSut.conditions?.first?.iconName
        // then
        XCTAssertEqual(comparedProperty, decodedProperty)
    }
    
    func test_FailureCase_CurrentData타입은_snakecaseKey가_nil데이터로할당된다() {
        // give

        // when
        let decodedProperty = currentSut.mainInformation?.maximumTemperature
        // then
        XCTAssertNil(decodedProperty)
    }
    
    // MARK: - FiveDayWeatherData 모델 디코딩 테스트
    func test_SuccessCase_FiveDayDaya타입은_decoding된다() {
        // give
        let comparedProperty: TimeInterval = 1633057200
        // when
        let decodedProperty = fivedaySut.intervalWeathers?.first?.date
        // then
        XCTAssertEqual(comparedProperty, decodedProperty)
    }
    
    func test_FailureCase_FiveDayDaya타입은_snakecaseKey가_nil데이터로할당된다() {
        // give

        // when
        let decodedProperty = fivedaySut.intervalWeathers?.first?.mainInformation?.maximumTemperature
        // then
        XCTAssertNil(decodedProperty)
    }
}
