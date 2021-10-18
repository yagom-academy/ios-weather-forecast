//
//  DecodingTests.swift
//  WeatherForecastTests
//
//  Created by Marco, Soll on 2021/10/01.
//

import XCTest
@testable import WeatherForecast

class DecodingTests: XCTestCase {
    
    // MARK: - CurrentWeatherData 모델 디코딩 테스트
    func test_SuccessCase_CurrentData타입은_decoding된다() {
        // give
        let decoder = JSONDecoder(keyDecodingStrategy: .convertFromSnakeCase)
        let data = try? getData(fromJSON: "MockCurrentWeatherData")
        let decoded = try! decoder.decode(CurrentWeatherData.self, from: data!)
        // when
        let comparedProperty = "01d"
        let decodedProperty = decoded.conditions[0].iconName
        // then
        XCTAssertEqual(comparedProperty, decodedProperty)
    }
    
    // MARK: - FiveDayWeatherData 모델 디코딩 테스트
    func test_SuccessCase_FiveDayDaya타입은_decoding된다() {
        // give
        let decoder = JSONDecoder(keyDecodingStrategy: .convertFromSnakeCase)
        let data = try? getData(fromJSON: "MockFiveDayWeatherData")
        let decoded = try! decoder.decode(FiveDayWeatherData.self, from: data!)
        // when
        let comparedProperty: TimeInterval = 1633057200
        let decodedProperty = decoded.intervalWeathers.first?.date
        // then
        XCTAssertEqual(comparedProperty, decodedProperty)
    }
}
