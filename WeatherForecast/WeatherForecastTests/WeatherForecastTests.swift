//
//  WeatherForecastTests - WeatherForecastTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
import CoreLocation
@testable import WeatherForecast

class WeatherForecastTests: XCTestCase {
    
    func test_getCurrentLocation_returnsExpectedLocation() {
        // given
        let expectLocation = CLLocation(latitude: 37.0, longitude: 100.0)
        // when
        let mockLocationManager = MockLocationManager()
        mockLocationManager.locationCompletion = {
            return CLLocation(latitude: 37.0, longitude: 100.0)
        }
        let sut = LocationManager(locationManager: mockLocationManager)
        let expectation = XCTestExpectation()
        // then
        sut.getUserLocation { location in
            expectation.fulfill()
            XCTAssertEqual(location.coordinate.latitude,
                           expectLocation.coordinate.latitude)
            XCTAssertEqual(location.coordinate.longitude,
                           expectLocation.coordinate.longitude)
        }
        wait(for: [expectation], timeout: 2)
    }
    
}
