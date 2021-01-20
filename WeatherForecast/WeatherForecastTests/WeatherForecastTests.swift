//
//  WeatherForecastTests - WeatherForecastTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import WeatherForecast

class WeatherForecastTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodeResponseDataOfCurrentWeatherAPI() {
        // Given-When-Then (준비-실행-검증)
        
        // Given
        guard let dataAsset = NSDataAsset(name: "ExampleResponseOfCurrentWeather") else {
            return
        }
        let jsonDecoder = JSONDecoder()
        let decodedData: CurrentWeather
        
        let coordinateLongitude = -122.08
        let coordinateLatitude = 37.39
        
        let weatherConditionID = 800
        let weatherGroup = "Clear"
        let weatherDescription = "clear sky"
        let weatherIcon = "01d"
        
        let temperatureCurrent = 282.55
        let temperatureHumanFeels = 281.86
        let temperatureMinimum = 280.37
        let temperatureMaximum = 284.26
        let temperatureAtmosphericPressure = 1023
        let temperatureHumidity = 100
        
        let utc = 1560350645
        let cityID = 420006353
        let cityName = "Mountain View"
        
        do {
            // When
            decodedData = try jsonDecoder.decode(CurrentWeather.self, from: dataAsset.data)
            
            // Then
            XCTAssertEqual(decodedData.coordinate.longitude, coordinateLongitude)
            XCTAssertEqual(decodedData.coordinate.latitude, coordinateLatitude)
            
            XCTAssertEqual(decodedData.weather.conditionID, weatherConditionID)
            XCTAssertEqual(decodedData.weather.group, weatherGroup)
            XCTAssertEqual(decodedData.weather.description, weatherDescription)
            XCTAssertEqual(decodedData.weather.iconID, weatherIcon)
            
            XCTAssertEqual(decodedData.temperature.current, temperatureCurrent)
            XCTAssertEqual(decodedData.temperature.humanFeels, temperatureHumanFeels)
            XCTAssertEqual(decodedData.temperature.minimum, temperatureMinimum)
            XCTAssertEqual(decodedData.temperature.maximum, temperatureMaximum)
            XCTAssertEqual(decodedData.temperature.atmosphericPressure, temperatureAtmosphericPressure)
            XCTAssertEqual(decodedData.temperature.humidity, temperatureHumidity)
            
            XCTAssertEqual(decodedData.utc, utc)
            XCTAssertEqual(decodedData.cityID, cityID)
            XCTAssertEqual(decodedData.cityName, cityName)
        } catch {
            print(error.localizedDescription)
        }
        
    }

}
