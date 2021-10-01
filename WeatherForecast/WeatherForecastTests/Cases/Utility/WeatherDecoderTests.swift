//
//  WeatherDecoderTests.swift
//  WeatherForecastTests
//
//  Created by Yongwoo Marco on 2021/10/01.
//

import XCTest
@testable import WeatherForecast

class WeatherDecoderTests: XCTestCase {
    var currentSut: CurrentData!

    override func setUpWithError() throws {
        super.setUp()
        let customDecoder = WeatherJSONDecoder()
        let currentData = try getData(fromJSON: "MockCurrentData")
        self.currentSut = try customDecoder.decode(CurrentData.self, from: currentData)
    }

    override func tearDownWithError() throws {
        currentSut = nil
        super.tearDown()
    }
    
    // MARK: - WeatherJSONDecoder 테스트
    func test_SuccessCase_CurrentData타입은_snakeCaseKey가_camelCase프로퍼티로할당된다() {
        // give
        let comparedProperty = 296.86
        // when
        let decodedProperty = currentSut.main?.feelsLike
        // then
        XCTAssertEqual(comparedProperty, decodedProperty)
    }
}
