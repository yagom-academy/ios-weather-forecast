//
//  DecodingTests.swift
//  WeatherForecastTests
//
//  Created by Yongwoo Marco on 2021/10/01.
//

import XCTest
@testable import WeatherForecast

class DecodingTests: XCTestCase {
    var currentSut: CurrentData!
    var fivedaySut: FiveDayData!

    override func setUpWithError() throws {
        super.setUp()
        let currentData = try getData(fromJSON: "MockCurrentData")
        self.currentSut = try JSONDecoder().decode(CurrentData.self, from: currentData)
        let fivedayData = try getData(fromJSON: "MockFiveDayData")
        self.fivedaySut = try JSONDecoder().decode(FiveDayData.self, from: fivedayData)
    }

    override func tearDownWithError() throws {
        currentSut = nil
        fivedaySut = nil
        super.tearDown()
    }
    
    // MARK: - CurrentData 모델 디코딩 테스트
    func test_SuccessCase_CurrentData타입은_decoding된다() {
        // give
        let comparedProperty = 1835848
        // when
        let decodedProperty = currentSut.cityID
        // then
        XCTAssertEqual(comparedProperty, decodedProperty)
    }
    
    // MARK: - FiveDayDaya 모델 디코딩 테스트
    func test_SuccessCase_FiveDayDaya타입은_decoding된다() {
        // give
        let comparedProperty = 1835848
        // when
        let decodedProperty = fivedaySut.city?.id
        // then
        XCTAssertEqual(comparedProperty, decodedProperty)
    }
}
