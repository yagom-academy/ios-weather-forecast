//
//  WeatherForecastTests - WeatherForecastTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import WeatherForecast

class WeatherForecastTests: XCTestCase {
    private let currentWeatherData: Data = { () -> Data in
        let apiURL = "https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=f08f782b840c2494b77e036d6bf2f3de"
        let data = try! Data(contentsOf: URL(string: apiURL)!, options: Data.ReadingOptions())
        
        return data
    }()
    
    private let foreCastFiveDaysData: Data = { () -> Data in
        let apiURL = "https://api.openweathermap.org/data/2.5/forecast?lat=35&lon=139&appid=f08f782b840c2494b77e036d6bf2f3de"
        let data = try! Data(contentsOf: URL(string: apiURL)!, options: Data.ReadingOptions())
        
        return data
    }()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testCurrentWeatherDataDecoding() throws {
        let result = try! JSONDecoder().decode(CurrentWeather.self, from: currentWeatherData)
        
        print(result.city)
        print(result.temperature)
        print(result.weather[0].icon)
    }
    
    func testForeCastFiveDaysData() throws {
        let result = try! JSONDecoder().decode(ForecastFiveDays.self, from: foreCastFiveDaysData)
        
        print(result.timeStampsCount)
        print(result.list)
    }
    
}
