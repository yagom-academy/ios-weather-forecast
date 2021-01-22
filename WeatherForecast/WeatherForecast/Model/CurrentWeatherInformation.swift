
import Foundation

struct GeographicCoordinate: Decodable {
    var latitude: Double
    var longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}

struct Weather: Decodable {
    var id: Int
    var main: String
    var description: String
    var iconID: String
    
    private enum CodingKeys: String, CodingKey {
        case id, main, description
        case iconID = "icon"
    }
}

struct Temperature: Decodable {
    var currentMeasurement: Double
    var minimumMeasurement: Double
    var maximumMeasurement: Double
    
    private enum CodingKeys: String, CodingKey {
        case currentMeasurement = "temp"
        case minimumMeasurement = "temp_min"
        case maximumMeasurement = "temp_max"
    }
}

struct CurrentWeatherInformation: Decodable {
    var geographicCoordinate: GeographicCoordinate
    var dataTimeCalculation: Double
    var cityName: String
    var weathers: [Weather]
    var temperature: Temperature
    
    private enum CodingKeys: String, CodingKey {
        case geographicCoordinate = "coord"
        case dataTimeCalculation = "dt"
        case cityName = "name"
        case weathers = "weather"
        case temperature = "main"
    }
}
