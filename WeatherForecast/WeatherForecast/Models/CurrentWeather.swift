import Foundation

struct CurrentWeather: Codable {
    let coordinate: Coordinate
    let cityID: Int
    let cityName: String
    let weather: [Weather]
    let temperature: Temperature
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case cityID = "id"
        case cityName = "name"
        case temperature = "main"
        case weather
    }
}
