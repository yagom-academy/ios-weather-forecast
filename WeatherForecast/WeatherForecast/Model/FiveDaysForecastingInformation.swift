
import Foundation

struct City: Decodable {
    let name: String
    let geographicCoordinate: GeographicCoordinate
    
    private enum CodingKeys: String, CodingKey {
        case name
        case geographicCoordinate = "coord"
    }
}

struct ForecastingInformation: Decodable {
    let dateTimeCalculation: Double
    let temperature: Temperature
    let weathers: [Weather]
    
    private enum CodingKeys: String, CodingKey {
        case dateTimeCalculation = "dt"
        case temperature = "main"
        case weathers = "weather"
    }
}

struct FiveDaysForecastingInformation: Decodable {
    let forecastingInformationList: [ForecastingInformation]
    let city: City
    
    private enum CodingKeys: String, CodingKey {
        case forecastingInformationList = "list"
        case city
    }
}
