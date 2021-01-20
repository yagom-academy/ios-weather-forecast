import XCTest
@testable import WeatherForecast

class WeatherForecastTests: XCTestCase {
    func testCurrentWeatherDataDecoding() throws {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=37.68382&lon=126.742401&appid=02337d7f6423f1596383c1797c318936") else {
            print("해당 URL 주소가 없습니다.")
            return
        }
        
        guard let jsonData = try String(contentsOf: url).data(using: .utf8) else {
            print("JSON 데이터가 없습니다.")
            return
        }
        
        let result = try JSONDecoder().decode(CurrentWeather.self, from: jsonData)
        
        print("현재 날씨예보 아이콘: " + "\(result.icon)")
        print("현재 날씨예보 평균온도: " + "\(result.temperature.celsiusAverage)")
        print("현재 날씨예보 최저온도: " + "\(result.temperature.celsiusMinimum)")
        print("현재 날씨예보 최고온도: " + "\(result.temperature.celsiusMaximum)")
    }
    
    func testForecastListDataDecoding() throws {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=37.68382&lon=126.742401&appid=02337d7f6423f1596383c1797c318936") else {
            print("해당 URL 주소가 없습니다.")
            return
        }
        
        guard let jsonData = try String(contentsOf: url).data(using: .utf8) else {
            print("JSON 데이터가 없습니다.")
            return
        }
        
        let result = try JSONDecoder().decode(ForecastList.self, from: jsonData)
        
        print("5일 날씨예보: " + "\(result.list)")
    }
}
