
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

struct ForecastingSystem {
    var currentWeatherInformation: CurrentWeatherInformation
    var fiveDaysForecastingInformation: FiveDaysForecastingInformation
}
