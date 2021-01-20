
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
    var iconId: String
    
    private enum CodingKeys: String, CodingKey {
        case id, main, description
        case iconId = "icon"
    }
}

struct Temperature: Decodable {
    var currentTemperature: Double
    var minimumTemperature: Double
    var maximumTemperature: Double
    
    private enum CodingKeys: String, CodingKey {
        case currentTemperature = "temp"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
    }
}

struct CurrentWeatherInformation: Decodable {
    var geographicCoordinate: GeographicCoordinate
    var dataTimeCalculation: Double
    var cityName: String
    var weather: [Weather]
    var temperature: Temperature
    
    private enum CodingKeys: String, CodingKey {
        case geographicCoordinate = "coord"
        case dataTimeCalculation = "dt"
        case cityName = "name"
        case weather
        case temperature = "main"
    }
}
