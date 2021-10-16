//
//  WeatherForecastTests - WeatherForecastTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import WeatherForecast

class WeatherForecastTests: XCTestCase {
    private var sut: LocationManager!
    
    func test_MockLocationManager가_주입된_sut를_통해_requestLocation_메서드를_호출하면_latitude와_longitude를_가져올_수_있다() {
        // given
        let exp = XCTestExpectation(description: "MockLocationManager")
        let latitude = 37.493370
        let longitude = 126.919701
        sut = .init(locationManager: MockLocationManager(latitude: latitude, longitude: longitude))
        // when
        sut.requestAuthorization { coordinate in
            // then
            XCTAssertEqual(latitude, coordinate.latitude)
            XCTAssertEqual(longitude, coordinate.longitude)
            exp.fulfill()
        }
        sut.requestLocation()
        wait(for: [exp], timeout: 2)
    }
    // TODOs : locationManager 의 didFailWithError 델리게이트의 내부 로직 구현 후 실패케이스 작성예정.
}
