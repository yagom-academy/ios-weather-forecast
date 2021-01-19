//
//  WeatherForecastTests - WeatherForecastTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import WeatherForecast

class WeatherForecastTests: XCTestCase {
    
    let decoder = JSONDecoder()
    let bundle = Bundle(for: WeatherForecastTests.self)
    
    func testDecodeCurrentWeatherResponseJSON() {
        let fileName = "CurrentWeatherResponse"
        
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            XCTFail("URL Error")
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Data Error")
            return
        }
        
        do {
            let result = try decoder.decode(CurrentWeatherResponse.self, from: data)
            print(result)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testDecodeFiveDayForecastResponseJSON() {
        let fileName = "FiveDayForecastResponse"
        
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            XCTFail("URL Error")
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Data Error")
            return
        }
        
        do {
            let result = try decoder.decode(FiveDayForecastResponse.self, from: data)
            print(result)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    

}
