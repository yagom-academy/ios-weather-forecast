//
//  WeatherDecoderTests.swift
//  WeatherForecastTests
//
//  Created by Marco, Soll on 2021/10/01.
//

import XCTest
@testable import WeatherForecast

class WeatherDecoderTests: XCTestCase {
    
    var currentSut: CurrentWeatherData!

    override func setUpWithError() throws {
        super.setUp()
        let decoder = JSONDecoder(keyDecodingStrategy: .convertFromSnakeCase)
        let currentData = try getData(fromJSON: "MockCurrentWeatherData")
        self.currentSut = try decoder.decode(CurrentWeatherData.self, from: currentData)
    }

    override func tearDownWithError() throws {
        currentSut = nil
        super.tearDown()
    }
    
    // MARK: - WeatherJSONDecoder 테스트
    func test_SuccessCase_CurrentData타입은_snakeCaseKey가_camelCase프로퍼티로할당된다() {
        // give
        let comparedProperty = "01d"
        // when
        let decodedProperty = currentSut.conditions[0].iconName
        // then
        XCTAssertEqual(comparedProperty, decodedProperty)
    }
}
