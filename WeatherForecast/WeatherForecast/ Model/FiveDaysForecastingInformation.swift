
import Foundation

struct City: Decodable {
    var name: String
    var geographicCoordinate: GeographicCoordinate
    
    private enum CodingKeys: String, CodingKey {
        case name
        case geographicCoordinate = "coord"
    }
}

struct ForecastingInformation: Decodable {
    var dateTimeCalculation: Double
    var temperature: Temperature
    var weather: [Weather]
    
    private enum CodingKeys: String, CodingKey {
        case dateTimeCalculation = "dt"
        case temperature = "main"
        case weather
    }
}

struct FiveDaysForecastingInformation: Decodable {
    var forecastingList: [ForecastingInformation]
    var city: City
    
    private enum CodingKeys: String, CodingKey {
        case forecastingList = "list"
        case city
    }
}
