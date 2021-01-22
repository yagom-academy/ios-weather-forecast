
import Foundation

struct GeographicCoordinate: Decodable {
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let iconID: String
    
    private enum CodingKeys: String, CodingKey {
        case id, main, description
        case iconID = "icon"
    }
}

struct Temperature: Decodable {
    let currentMeasurement: Double
    let minimumMeasurement: Double
    let maximumMeasurement: Double
    
    private enum CodingKeys: String, CodingKey {
        case currentMeasurement = "temp"
        case minimumMeasurement = "temp_min"
        case maximumMeasurement = "temp_max"
    }
}

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
