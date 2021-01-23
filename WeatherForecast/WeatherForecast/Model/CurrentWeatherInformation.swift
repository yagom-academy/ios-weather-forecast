
import Foundation

struct CurrentWeatherInformation: Decodable {
    let geographicCoordinate: GeographicCoordinate
    let dataTimeCalculation: Double
    let cityName: String
    let weathers: [Weather]
    let temperature: Temperature
    
    private enum CodingKeys: String, CodingKey {
        case geographicCoordinate = "coord"
        case dataTimeCalculation = "dt"
        case cityName = "name"
        case weathers = "weather"
        case temperature = "main"
    }
}
